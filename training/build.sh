#!/bin/bash

if [ "$1" == "coupled" ]; then
    echo "Building coupled Docker image..."
    docker build -t wrfhydro/training:coupled -f Dockerfile.coupled
if [ "$1" == "uncoupled" ]; then
    echo "Building uncoupled Docker image..."
    docker build -t wrfhydro/training:uncoupled -f Dockerfile.uncoupled
else
    echo "Building both Docker images (coupled and uncoupled)..."
    docker build -t wrfhydro/training:coupled -f Dockerfile.coupled
    docker build -t wrfhydro/training:uncoupled -f Dockerfile.uncoupled
fi

exit $?
