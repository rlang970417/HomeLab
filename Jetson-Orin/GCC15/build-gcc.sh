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
if [ ! -f ../src/binutils-${BINUTL_VERSION}.tar.bz2 ]; then
  echo "Error : Unable to locate package : ../src/binutils-${BINUTL_VERSION}.tar.bz2"
  exit 1
else
  echo "Package located : ../src/binutils-${BINUTL_VERSION}.tar.bz2"
fi

if [ ! -f ../src/gmp-${GMP_VERSION}.tar.bz2 ]; then
  echo "Error : Unable to locate package : ../src/gmp-${GMP_VERSION}.tar.bz2"
  exit 1
else
  echo "Package located : ../src/gmp-${GMP_VERSION}.tar.bz2"
fi

if [ ! -f ../src/mpfr-${MPFR_VERSION}.tar.bz2 ]; then
  echo "Error : Unable to locate package : ../src/mpfr-${MPFR_VERSION}.tar.bz2"
  exit 1
else
  echo "Package located : ../src/mpfr-${MPFR_VERSION}.tar.bz2"
fi

if [ ! -f ../src/mpc-${MPC_VERSION}.tar.gz ]; then
  echo "Error : Unable to locate package : ../src/mpc-${MPC_VERSION}.tar.gz"
  exit 1
else
  echo "Package located : ../src/mpc-${MPC_VERSION}.tar.gz"
fi

if [ ! -f ../src/gcc-${GCC_FULL_VERSION}.tar.gz ]; then
  echo "Error : Unable to locate package : ../src/gcc-${GCC_FULL_VERSION}.tar.gz"
  exit 1
else
  echo "Package located : ../src/gcc-${GCC_FULL_VERSION}.tar.gz"
fi

cd ${BLD_WORKING_DIR}
if [ -d ./${BLD_WORKING_DIR}/binutils-${BINUTL_VERSION} ]; then
   rm -fr ./${BLD_WORKING_DIR}/binutils-${BINUTL_VERSION}
fi
# Build and Install binutils
tar -jxvf ../src/binutils-${BINUTL_VERSION}.tar.bz2
cd ${BLD_WORKING_DIR}/binutils-${BINUTL_VERSION}
./configure --prefix=${GCC_HOME} --disable-nls --disable-werror
make -j 3
make install

cd ${BLD_WORKING_DIR}
if [ -d ./${BLD_WORKING_DIR}/gmp-${GMP_VERSION} ]; then
   rm -fr ./${BLD_WORKING_DIR}/gmp-${GMP_VERSION}
fi
# Build and Install gmp
tar -jxvf ../src/gmp-${GMP_VERSION}.tar.bz2
cd ${BLD_WORKING_DIR}/gmp-${GMP_VERSION}
./configure --prefix=${GCC_HOME} --enable-cxx
make -j 3
make install

cd ${BLD_WORKING_DIR}
if [ -d ./${BLD_WORKING_DIR}/mpfr-${MPFR_VERSION} ]; then
   rm -fr ./${BLD_WORKING_DIR}/mpfr-${MPFR_VERSION}
fi
# Build and Install mpfr
tar -jxvf ../src/mpfr-${MPFR_VERSION}.tar.bz2
cd ${BLD_WORKING_DIR}/mpfr-${MPFR_VERSION}
./configure --prefix=${GCC_HOME} --with-gmp=${GCC_HOME}
make -j 3
make install

cd ${BLD_WORKING_DIR}
if [ -d ./${BLD_WORKING_DIR}/mpc-${MPC_VERSION} ]; then
   rm -fr ./${BLD_WORKING_DIR}/mpc-${MPC_VERSION}
fi
# Build and Install mpc
tar -zxvf ../src/mpc-${MPC_VERSION}.tar.gz
cd ${BLD_WORKING_DIR}/mpc-${MPC_VERSION}
./configure --prefix=${GCC_HOME} --with-gmp=${GCC_HOME} --with-mpfr=${GCC_HOME}
make -j 3
make install

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
make -j 3
make install
