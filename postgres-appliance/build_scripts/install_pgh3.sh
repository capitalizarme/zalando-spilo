#!/bin/sh
#
# PGH3 :
# This extension integrates with the PostGIS geometry type. 
# Namely Point, Polygon and MultiPolygon geometries are supported.
#
# Require:
#     cmake \
#     make \
#     gcc \
#     libtool \
#     clang-format \
#     cmake-curses-gui \
#     lcov \
#     doxygen \
#     postgresql-server-dev-all
#
# Author: Roy Alvear <racl@fedoraproject.org>
#
set -ex

version=$1
PGVERSION=$2

if [ ! -d "pgh3" ]; then 
    git clone https://github.com/dlr-eoc/pgh3.git
fi

# pgh3 require h3
if [ ! -d "h3" ]; then
    git clone https://github.com/uber/h3.git
fi

cp -ar pgh3 pgh3_${version}

# build h3
mkdir h3/build
cd h3/build
git checkout v3.7.2
cmake -DCMAKE_C_FLAGS=-fPIC ..
make
make install

# build pgh3
cd ../../pgh3_${version}
make
make install
cd ..

# clean source
rm -rf h3/build pgh3_${version}

if [ ${PGVERSION} -eq ${version} ]; then
    rm -rf h3 pgh3
fi
