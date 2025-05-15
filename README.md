#  WRF-Hydro® Docker Images <img src="https://ral.ucar.edu/sites/default/files/public/wrf_hydro_symbol_logo_2017_09_150pxby63px.png" width=100 align="left" />

![Build](https://github.com/NCAR/wrf_hydro_docker/actions/workflows/docker-build.yml/badge.svg)

# Description

This repository contains Dockerfiles and associated container contents for [WRF-Hydro](https://github.com/NCAR/wrf_hydro_nwm_public).
These images are available on the [WRF-Hydro Docker Hub page](https://hub.docker.com/u/wrfhydro/).
Large datasets are sometimes required and are avilable on a public Google Drive folder at
[WRF_HYDRO_DOCKER_DATA](https://drive.google.com/open?id=1NY9YdVLcJMIqE6ibLVyKe1fJ-Eoj74Kr).

Each subdirectory in this repository corresponds to a Docker image on the [WRF-Hydro Docker Hub page]
(https://hub.docker.com/u/wrfhydro/).

## Where to get help and/or post issues
If you have general questions about Docker, there are ample online resources including the excellent Docker documentation at https://docs.docker.com/.

The best place ask questions or post issues with these lessons is via the Issues page of the GitHub
repository at https://github.com/NCAR/wrf_hydro_docker/issues.



# Docker Package and Training Charts
## Docker Packages Flowchart
```mermaid
flowchart TD
  base([wrfhydro/dev:base]) --> dev([wrfhydro/dev])
  dev --> training([wrfhydro/training])

  base --> |installs| base_installs
  base_installs[
    Compilers
    CMake
    Editors
    Git
    MPI
    NetCDF
    Nccmp
    ]

  dev --> |installs| dev_installs
  dev --> |conda installs| miniconda_installs
  dev_installs[
    Python
    R
    R NetCDF4
    Gdal
    Valgrind
    Miniconda
    NodeJS
    NCO
    ]

  miniconda_installs[
    Dask
    ESMPy
    Gdal
    Gdown
    Geopandas
    Hvplot
    Jupyter Lab
    MPI4Py
    OpenMPI
    RasterIO
    SQLite
    Whitebox
    XrViz
  ]

  training --> |installs| training_installs
  training_installs[
    WRF
    WPS
  ]
```



## Training Flowchart
```mermaid
flowchart TD
  subgraph docker[Docker Images]
  base([wrfhydro/dev:base]) --> dev([wrfhydro/dev])
  dev --> training
  subgraph training[wrfhydro/training]
    ep([Croton entryPoint.sh])


  ep --> |downloads| Repos
  ep --> |downloads| Data
  subgraph Repos
    wrf_hydro_nwm_public
    wrf_hydro_training[scrasmussen/wrf_hydro_training]
    WrfHydroForcing
    wrf_hydro_model_tools
    GIS_Training[scrasmussen/GIS_Training]
    wrf_hydro_gis_preprocessor
  end
  subgraph Data
    croton.tar.gz
    nldas_mfe_forcing.tar.gz
    geog_conus.tar.gz
  end
  end
  end

  training --> notebooks
  subgraph notebooks[Training Lessons]
   supplemental[Lesson-S3-regridding.py
                edits nldas_fe.config from
                nldas_mfe_forcing.tar.gz]
  end
```
