#!/bin/bash

# 1. Download files
source ./set-envs.sh
cd /usr/local/src

wget http://ftp.gnu.org/gnu/binutils/binutils-${BINUTL_VERSION}.tar.bz2
wget http://ftp.gnu.org/gnu/gcc/gcc-${GCC_FULL_VERSION}/gcc-${GCC_FULL_VERSION}.tar.gz
wget https://ftp.gnu.org/gnu/gmp/gmp-${GMP_VERSION}.tar.bz2
wget https://ftp.gnu.org/gnu/mpc/mpc-${MPC_VERSION}.tar.gz
wget http://www.mpfr.org/mpfr-${MPFR_VERSION}/mpfr-${MPFR_VERSION}.tar.bz2
