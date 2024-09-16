FROM wrfhydro/training:coupled
USER root

ARG DEBIAN_FRONTEND=noninteractive

# RUN apt-get update \
#     && apt-get install -yq --no-install-recommends \
#     file \
#     libcurl4-gnutls-dev \
#     libpng-dev \
#     libssl-dev \
#     openssh-client \
#     && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Install jasper to support grib2
RUN wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz -P /tmp \
    && tar -xf /tmp/jasper*tar.gz -C /tmp \
    && cd /tmp/jasper* \
    && ./configure --prefix=${LIB_DIR} \
    && make \
    && make install \
    && rm -rf /tmp/jasper*

RUN chmod -R 777 /home/docker/

# Set paths to required libraries
ENV NETCDF=/usr/local
ENV JASPERLIB=/usr/lib
ENV JASPERINC=/usr/include

# Set WRF-Hydro environment variables
ENV WRF_HYDRO=1
ENV HYDRO_D=1
ENV SPATIAL_SOIL=0
ENV WRF_HYDRO_RAPID=0
ENV WRFIO_NCD_LARGE_FILE_SUPPORT=1
ENV WRF_HYDRO_NUDGING=0

#Get the entrypoint script to download the code, example case, and lessons and start JupyterLab
COPY ./entrypoint.sh /.
USER docker
WORKDIR /home/docker
ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]
