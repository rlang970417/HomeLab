#!/bin/bash

# Source our config for versioning
source ./set-envs.sh

# Set environment variables
export TGT_ROOT_DIR=/usr/local
export GCC_HOME=${TGT_ROOT_DIR}/gcc/${GCC_MAJOR_VERSION}
export BLD_WORKING_DIR=${TGT_ROOT_DIR}/build

export CC=/usr/local/gcc/14/bin/gcc
export CXX=/usr/local/gcc/14/bin/g++
export LD_LIBRARY_PATH=${GCC_HOME}/lib64:/usr/local/gcc/14/lib64:/usr/local/gcc/14/lib:${TGT_ROOT_DIR}:/usr/lib
export PATH=${GCC_HOME}/bin:${TGT_ROOT_DIR}/sbin:${TGT_ROOT_DIR}/bin:/usr/sbin:/usr/bin:/sbin:/bin


# Verify Source Code Packages are in the "src" Directory
if [ ! -f ../src/gcc-${GCC_FULL_VERSION}.tar.gz ]; then
  echo "Error : Unable to locate package : ../src/gcc-${GCC_FULL_VERSION}.tar.gz"
  exit 1
else
  echo "Package located : ../src/gcc-${GCC_FULL_VERSION}.tar.gz"
fi

# Build and install GCC
#   Note : This will take 2 or more hours depending on hardware resources
cd ${BLD_WORKING_DIR}
tar -zxvf ../src/gcc-${GCC_FULL_VERSION}.tar.gz
if [ -d ./gcc-build ];then
  rm -fr ./gcc-build
fi

mkdir ./gcc-build
cd ./gcc-build
../gcc-${GCC_FULL_VERSION}/configure --prefix=${GCC_HOME} -enable-threads=posix -disable-checking -disable-multilib -enable-languages=c,c++ -with-gmp=${GCC_HOME} -with-mpfr=${GCC_HOME} -with-mpc=${GCC_HOME}
make
make install
