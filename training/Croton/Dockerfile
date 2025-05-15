FROM wrfhydro/dev:latest
USER root

# RUN locale-gen en_US.UTF-8
# ENV LANG en_US.UTF-8
# ENV LC_ALL en_US.UTF-8

# WRF and WPS installs
# Set WRF and WPS version argument
ARG WRF_VERSION="4.6.1"
ARG WPS_VERSION="4.6.0"

WORKDIR /home/docker/WRF_WPS

RUN git clone --branch v${WRF_VERSION} --depth 1 --recurse-submodules https://github.com/wrf-model/WRF.git
RUN git clone --branch v${WPS_VERSION} --depth 1 --recurse-submodules https://github.com/wrf-model/WPS.git

# Build WRF first, required for WPS
WORKDIR /home/docker/WRF_WPS/WRF
RUN printf '34\n1\n' | git submodule update --init --recursive
RUN printf '34\n1\n' | \
    ./configure_new -x -p gnu -- -DWRF_CASE=EM_REAL -DCMAKE_SKIP_RPATH=ON
RUN printf '34\n1\n' | ./compile_new -j4

# Build WPS second after WRF is built
WORKDIR /home/docker/WRF_WPS/WPS

RUN printf '2\n' | \
    ./configure_new -x -p gfortran -- -DBUILD_EXTERNALS=1 -DCMAKE_Fortran_FLAGS="-fallow-argument-mismatch" -DCMAKE_SKIP_RPATH=ON
RUN printf '34\n1\n' | VERBOSE=1 ./compile_new -j2
ENV PATH=/home/docker/WRF_WPS/WPS/install/bin:$PATH

# Clean-up WRF but keep install directory
RUN mv /home/docker/WRF_WPS/WRF/install /home/docker/WRF_WPS/wrf_install \
    && rm -rf /home/docker/WRF_WPS/WRF \
    && mkdir /home/docker/WRF_WPS/WRF \
    && mv /home/docker/WRF_WPS/wrf_install /home/docker/WRF_WPS/WRF/install

# ##################################
RUN install -d -m 0777 \
    /home/docker/wrf-hydro-training \
    /home/docker/GIS_Training

# #################################
# #Get the Jupyter configuration script
# COPY ./jupyter_notebook_config.py /home/docker/.jupyter/
# RUN chmod -R 777 /home/docker/.jupyter

# #################################
# #Get the entrypoint script to download the code, example case, and lessons and start JupyterLab
COPY ./entrypoint.sh /.

RUN set +x /entrypoint.sh \
    && chmod -R 777 /home/docker/wrf-hydro-training/ \
    && chmod -R 777 /home/docker/WRF_WPS/
#     # && chmod -R 777 /home/docker/miniconda3/

USER docker
WORKDIR /home/docker
ENV SHELL=bash
ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]
