![](https://ral.ucar.edu/sites/default/files/public/wrf_hydro_symbol_logo_2017_09_150pxby63px.png) WRF-HYDRO

Containers used for WRF-Hydro Training.
The training directories are uncoupled unless they countain "coupled" in their name.

---------------------------------------------------

## build
Build both uncoupled and coupled training Docker images.
```
$ bash build.sh
```

Build only the uncoupled training Docker image.
```
$ bash build.sh uncoupled
```

Build only the coupled training Docker image.
```
$ bash build.sh coupled
```
