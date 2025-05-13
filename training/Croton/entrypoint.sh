#!/bin/bash

###Change the versions here
version_short=v5.4
version_full=${version_short}.0
training_branch=enhancement/v5.4.0-updates
###########################

###########################
echo -e "\e[4;49;34m WRF-Hydro Training Container\e[0m"
echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving model code\e[0m"

set -e -x
wget -nv https://github.com/NCAR/wrf_hydro_nwm_public/archive/${version_full}.tar.gz
{ set +x; } 2>/dev/null
tar -zxf ${version_full}.tar.gz
mv /home/docker/wrf_hydro_nwm_public* /home/docker/wrf-hydro-training/wrf_hydro_nwm_public
rm ${version_full}.tar.gz
echo "Retrieved the model code"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving testcase\e[0m"

set -e -x
wget -nv https://github.com/NCAR/wrf_hydro_nwm_public/releases/download/${version_full}/croton_NY_training_example_${version_short}.tar.gz
{ set +x; } 2>/dev/null
tar -zxf croton*.tar.gz
mv /home/docker/example_case /home/docker/wrf-hydro-training/example_case
rm croton*.tar.gz
echo "Retrieved the testcase"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving WRF-Hydro training\e[0m"

set -e -x
git clone --depth 1 --branch ${training_branch} https://github.com/scrasmussen/wrf_hydro_training
set +e +x
echo "Retrieved the training"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving WRF-Hydro Tools and Data\e[0m"
set -e -x
git clone --depth 1 https://github.com/NCAR/WrfHydroForcing.git
{ set +x; } 2>/dev/null
mv /home/docker/WrfHydroForcing /home/docker/wrf-hydro-training/WrfHydroForcing

set -e -x
git clone --depth 1 https://github.com/NCAR/wrf_hydro_model_tools.git
{ set +x; } 2>/dev/null
mv /home/docker/wrf_hydro_model_tools /home/docker/wrf-hydro-training/wrf_hydro_model_tools

set -e -x
gdown https://drive.google.com/uc?id=10Q-0eVakrVmFwZ27ftDDtsSHsg0YBQAT
{ set +x; } 2>/dev/null
mkdir /home/docker/wrf-hydro-training/regridding
mv nldas*.tar.gz /home/docker/wrf-hydro-training/regridding/nldas_mfe_forcing.tar.gz


gdown 1X71fdaSEJ5GWyNY2MDIy9cC6E7A0kihl
tar zxf geog_conus.tar.gz
rm geog_conus.tar.gz
mkdir /home/docker/WRF_WPS/utilities
mv /home/docker/geog_conus /home/docker/WRF_WPS/utilities

echo "Retrieved the tools and data"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving the GIS training\e[0m"

git clone --depth 1 --branch wrf-hydro-v5.4-updates https://github.com/scrasmussen/GIS_Training

echo "Retrieved the GIS training"

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mRetrieving GIS preprocessor\e[0m"

set -e -x
git clone --depth 1 https://github.com/NCAR/wrf_hydro_gis_preprocessor.git
{ set +x; } 2>/dev/null

cp wrf_hydro_gis_preprocessor/wrfhydro_gis/Create_Domain_Boundary_Shapefile.py \
   /home/docker/GIS_Training/
export PYTHONPATH=/home/docker/wrf_hydro_gis_preprocessor/wrfhydro_gis:$PYTHONPATH

echo "Retrieved the GIS preprocessor"


# if flag is true, run CI tests
if [ "${CI_TESTING:-}" = "true" ]; then
    echo "Running in CI testing mode"
    cd /home/docker/wrf_hydro_training/tests
    bash run_training_notebooks.sh
    exit $?

# if not in interactive mode, run as a server for training
elif [ ! -t 0 ]; then
    echo
    echo -e "\e[0;49;32m-----------------------------------\e[0m"
    echo -e "Training Jupyter notebook server running"
    echo
    echo "Open your browser to the following address to access notebooks"
    echo -e "\033[92;7mhttp://localhost:8888\033[0m"
    echo
    echo "Press ctrl-C then type 'y' then press return to shut down container."
    echo "NOTE ALL WORK WILL BE LOST UNLESS copied out of the container"

    set -e
    exec jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token='' --NotebookApp.password='' &> /dev/null

else
    for arg in "$@"; do
        if [ "$arg" = "interactive" ]; then
            exec bash
        fi
    done

    # Default: run passed command
    exec "$@"
fi
