#!/bin/sh
#
# PGH3 :
# This extension integrates with the PostGIS geometry type. 
# Namely Point, Polygon and MultiPolygon geometries are supported.
#
#
set -ex

version=$1
PGVERSION=$2

Plib='/usr/lib/postgresql'
Pshare='/usr/share/postgresql'

apt update
apt install -y \
    cmake \
    make \
    gcc \
    libtool \
    clang-format \
    cmake-curses-gui \
    lcov \
    doxygen \
    postgresql-server-dev-all

git clone https://github.com/dlr-eoc/pgh3.git
git clone https://github.com/uber/h3.git

mkdir h3/build
cd h3/build
git checkout v3.7.2
cmake -DCMAKE_C_FLAGS=-fPIC ..
make
make install

cd ../../pgh3
make
make install
cd ..

if [ ${PGVERSION} -ne ${version} ]; then
    cp -ar ${Plib}/${PGVERSION}/lib/pgh3.so ${Plib}/${version}/lib/pgh3.so
    cp -ar ${Pshare}/${PGVERSION}/extension/pgh3.control ${Pshare}/${version}/extension/pgh3.control
    cp -ar ${Pshare}/${PGVERSION}/extension/pgh3--0.3.0.sql ${Pshare}/${version}/extension/pgh3--0.3.0.sql
fi

# clean source
rm -rf h3 pgh3
