#!/bin/bash

if [ ! -d "/fluffos-build.lock" ]; then
    #   Build FluffOs, package_uids disabled
    cd /opt/docker/fluffos/
    git checkout v2019
    mkdir build && cd build
    cmake -DPACKAGE_UIDS=OFF ..
    make

    cp ./src/{driver,portbind} /opt/docker/docker_fluffos/bin/

    touch /fluffos-build.lock
fi
