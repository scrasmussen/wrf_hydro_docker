###################################
# WRF-Hydro Training Dockerfile
# Author: Katelyn FitzGerald
# Date:   2020-10-28
###################################


FROM ubuntu:24.04

USER root

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -yq --no-install-recommends software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

####################################
## Dependencies
RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
    bc\
    bzip2 \
    ca-certificates \
    cmake \
    cmake-curses-gui \
    csh \
    curl \
    cython3 \
    emacs-nox \
    file \
    g++ \
    gdal-bin \
    gfortran \
    git \
    less \
    libcurl4-gnutls-dev \
    libgdal-dev \
    libhdf5-dev \
    libhdf5-openmpi-dev \
    libnetcdf-pnetcdf-19 \
    libnetcdf-dev \
    libnetcdff-dev \
    libnetcdff7 \
    libopenmpi-dev \
    libpng-dev \
    libswitch-perl \
    libssl-dev \
    libxml2-dev \
    locales \
    m4 \
    make \
    nano \
    nco \
    netcdf-bin \
    nodejs \
    openmpi-bin \
    openssh-client \
    pkg-config \
    python3-dask \
    python3-geopandas \
    python3-ipython \
    python3-ipywidgets \
    python3-h5py \
    python3-mpi4py \
    python3-matplotlib \
    python3-netcdf4 \
    python3-numpy \
    python3-pyproj \
    python3-rasterio \
    python3-toolz \
    python3-xarray \
    r-base-core \
    tcsh \
    valgrind \
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/*

    # texlive-xetex \
    # texlive-plain-generic \
    # texlive-fonts-recommended \


RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# ## Download, build, and install MPICH
# RUN MPICH_VERSION="4.1.2" \
#     && MPICH_CONFIGURE_OPTIONS="" \
#     && FCFLAGS="-fallow-argument-mismatch" \
#     && mkdir /tmp/mpich-src \
#     && cd /tmp/mpich-src \
#     && wget http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz \
#     && tar xfz mpich-${MPICH_VERSION}.tar.gz \
#     && cd mpich-${MPICH_VERSION}  \
#     && FCFLAGS=${FCFLAGS} ./configure ${MPICH_CONFIGURE_OPTIONS}  \
#     && make -j 2 && make install \
#     && rm -rf /tmp/mpich-src


# ## NetCDF installs
# RUN NETCDF_C_VERSION="4.9.2" \
#     && wget https://github.com/Unidata/netcdf-c/archive/refs/tags/v${NETCDF_C_VERSION}.tar.gz -P /tmp \
#     && tar -xf /tmp/v${NETCDF_C_VERSION}.tar.gz -C /tmp \
#     && cd /tmp/netcdf-c-${NETCDF_C_VERSION} \
#     && CPPFLAGS=-I${H5DIR}/include LDFLAGS=-L${H5DIR}/lib ./configure --prefix=/usr/local \
#     && cd /tmp/netcdf-c-${NETCDF_C_VERSION} \
#     && make -j 2 \
#     && cd /tmp/netcdf-c-${NETCDF_C_VERSION} \
#     && make install \
#     && rm -rf /tmp/netcdf-c-${NETCDF_C_VERSION}

# # install netcdf-Fortran
# ENV NFDIR=/usr/local
# ENV LD_LIBRARY_PATH=${NCDIR}/lib
# RUN NETCDF_F_VERSION="4.6.1" \
#     && cd /tmp \
#     && wget https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v${NETCDF_F_VERSION}.tar.gz \
#     && tar -xf v${NETCDF_F_VERSION}.tar.gz \
#     && cd /tmp/netcdf-fortran-${NETCDF_F_VERSION} \
#     && CPPFLAGS=-I${NCDIR}/include LDFLAGS=-L${NCDIR}/lib ./configure --prefix=${NFDIR} \
#     && make -j 2\
#     && make install \
#     && cd / \
#     && rm -rf /tmp/netcdf-fortran-${NETCDF_F_VERSION}

# Install netCDF-C
ENV NCDIR=/usr/local
ENV NFDIR=/usr/local
ENV H5DIR=/usr/lib/x86_64-linux-gnu/hdf5/serial
ENV HDF5_DIR=/usr/lib/x86_64-linux-gnu/hdf5/serial

## just to be sure
RUN rm -rf /tmp/*


#################################
## Python installs
RUN wget -nv https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /home/docker/miniconda3 \
    && rm Miniconda3-latest-Linux-x86_64.sh \
    && chmod -R 777 /home/docker/miniconda3/
    # && chown -R docker:docker /home/docker/miniconda3


#################################
## Create docker user
RUN useradd -ms /bin/bash docker
RUN usermod -aG sudo docker
RUN chmod -R 777 /home/docker/
#################################

## WRF and WPS installs
#Set WRF and WPS version argument
ARG WRF_VERSION="4.6.0"
ARG WPS_VERSION="4.6.0"
WORKDIR /home/docker/WRF_WPS
RUN git clone --recurse-submodules https://github.com/wrf-model/WRF.git \
  --branch v${WRF_VERSION} --depth 1 --shallow-submodules
RUN wget -nv https://github.com/wrf-model/WPS/archive/v${WPS_VERSION}.tar.gz \
	&& tar -zxf v${WPS_VERSION}.tar.gz \
        && mv WPS-${WPS_VERSION} WPS \
	&& rm v${WPS_VERSION}.tar.gz

# Set paths to required libraries
ENV NETCDF=/usr/local

# # Build WRF first, required for WPS
WORKDIR /home/docker/WRF_WPS/WRF
RUN ./configure_new -x \
    -p gfortran/gcc \
    -- \
    -DENABLE_HYDRO=ON \
    -DWRF_CORE=ARW \
    -DWRF_NESTING=BASIC \
    -DWRF_CASE=EM_REAL
WORKDIR /home/docker/WRF_WPS/WRF
RUN make -j 4 -C _build # WRF doesn't build with -j right now
WORKDIR /home/docker/WRF_WPS/WRF
RUN make -C _build install


RUN mkdir /home/docker/jasper
# Build Jasper for WPS
WORKDIR /home/docker/jasper
RUN VERSION=4.2.4 \
    && wget -nv https://github.com/jasper-software/jasper/releases/download/version-${VERSION}/jasper-${VERSION}.tar.gz
WORKDIR /home/docker/jasper
RUN VERSION=4.2.4 \
    && tar zxf jasper-${VERSION}.tar.gz
WORKDIR /home/docker/jasper
RUN cmake -B build jasper-4.2.4 -DCMAKE_INSTALL_PREFIX=/home/docker/jasper \
    && make -C build -j \
    && make -C build install

# Build WPS second after WRF is built
ENV Jasper_ROOT=/home/docker/jasper
WORKDIR /home/docker/WRF_WPS/WPS
RUN sed -i 's/find_package( Jasper 1\.900\.1\.\.\.1\.900\.29 REQUIRED )/find_package( Jasper REQUIRED )/' CMakeLists.txt \
    && ./configure_new -x \
    -p gfortran \
    -- \
    -DBUILD_EXTERNALS=OFF \
    -DUSE_WRF=ON \
    -DUSE_MPI=ON \
    && make -j 4 -C _build/ \
    && make -C _build/ install
RUN chmod -R 777 /home/docker/WRF_WPS

# # Now delete WRF to save space
RUN rm -rf /home/docker/WRF_WPS/WRF

#Set environment variables
ENV PATH="/home/docker/miniconda3/bin:${PATH}"
WORKDIR /home/docker

RUN conda install -y -c conda-forge \
    bash_kernel \
    conda-project \
    esmpy \
    gdown \
    hvplot \
    ipyleaflet \
    ipympl \
    jupyterlab \
    jupyter_contrib_nbextensions \
    nccmp \
    whitebox \
    xrviz

## R installs
RUN wget https://cran.r-project.org/src/contrib/ncdf4_1.23.tar.gz \
        && R CMD INSTALL ncdf4_1.23.tar.gz  \
        && rm ncdf4_1.23.tar.gz \
        && Rscript -e 'install.packages(c("optparse","stringr","plyr"), repos="https://cran.rstudio.com")'

#################################
RUN gdown https://drive.google.com/uc?id=1X71fdaSEJ5GWyNY2MDIy9cC6E7A0kihl \
       && tar -xzvf geog_conus.tar.gz \
       && mkdir /home/docker/WRF_WPS/utilities \
       && mv geog_conus /home/docker/WRF_WPS/utilities \
       && rm geog_conus.tar.gz

# #################################
RUN mkdir /home/docker/wrf-hydro-training \
        && chmod -R 777 /home/docker/wrf-hydro-training \
        && mkdir /home/docker/GIS_Training \
        && chmod -R 777 /home/docker/GIS_Training

#################################
#Get the Jupyter configuration script
COPY ./jupyter_notebook_config.py /home/docker/.jupyter/
RUN chmod -R 777 /home/docker/.jupyter

#################################
#Get the entrypoint script to download the code, example case, and lessons and start JupyterLab
COPY ./entrypoint.sh /.
RUN chmod 777 /entrypoint.sh
RUN chmod -R 777 /home/docker/wrf-hydro-training/
RUN chmod -R 777 /home/docker/GIS_Training/
RUN chmod -R 777 /home/docker/WRF_WPS/

USER docker
WORKDIR /home/docker

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/home/docker/miniconda3/bin
ENV SHELL=bash
ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]
