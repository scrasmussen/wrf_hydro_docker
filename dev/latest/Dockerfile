FROM wrfhydro/dev:base
USER root

# install dependencies
RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
    bc \
    gdal-bin \
    libgdal-dev \
    libpng-dev \
    libssl-dev \
    libswitch-perl \
    libxml2-dev \
    locales \
    m4 \
    nco \
    nodejs \
    pkg-config \
    python3.12 \
    python3-dask \
    python3-geopandas \
    python3-ipython \
    python3-ipywidgets \
    python3-h5py \
    python3-mpi4py \
    python3-matplotlib \
    python3-netcdf4 \
    python3-numpy \
    python3-pip \
    python3-pyproj \
    python3-rasterio \
    python3-toolz \
    python3-xarray \
    r-base-core \
    valgrind \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --config csh

# cleanup
RUN rm -rf /tmp/*
RUN chmod -R 777 /home/docker/

# Miniforge and remaining Python packages
WORKDIR /home/docker
RUN wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh \
    && bash Miniforge3-Linux-x86_64.sh -b -p /home/docker/miniforge3 \
    && rm Miniforge3-Linux-x86_64.sh \
    && chown -R docker:docker /home/docker/miniforge3
ENV PATH="/home/docker/miniforge3/bin:${PATH}"
RUN mamba install -y -c conda-forge \
    python=3.12 \
    bash_kernel \
    conda-project \
    dask \
    esmpy \
    gdal \
    gdown \
    geopandas \
    hvplot \
    ipyleaflet \
    ipympl \
    jupyterlab \
    jupyter_contrib_nbextensions \
    mpi4py \
    openmpi \
    rasterio \
    sqlite \
    whitebox \
    xrviz
# RUN chmod -R a+rwx /home/docker/miniforge3/

# R packages
RUN ver=1.24 \
    && wget https://cran.r-project.org/src/contrib/ncdf4_${ver}.tar.gz \
    && R CMD INSTALL ncdf4_${ver}.tar.gz  \
    && rm ncdf4_${ver}.tar.gz \
    && Rscript -e 'install.packages(c("optparse","stringr","plyr"), repos="https://cran.rstudio.com")'

# # Jupyter configuration script
# COPY ./jupyter_notebook_config.py /home/docker/.jupyter/
# RUN chmod -R 777 /home/docker/.jupyter

USER docker
WORKDIR /home/docker
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/home/docker/miniforge3/bin
ENV SHELL=bash
