# Build GCC 15 on the Jetson Orin Nano

## Introduction

A series of shell scripts to build GCC 15 on the Jetson Orin Nano. These scripts rely upon GCC 14 already being built and deployed.


1. Source the 'set-envs.sh' script to define your packages versions
```bash
    source ./set-envs.sh
```

2. Run the script 'fetch-gcc.sh' to download all source packages
```bash
    ./fetch-gcc.sh
```

3. Build GCC with the following. Note : This is about a two hour process on the Jetson Orin Nano Super.
```bash
    ./build-gcc.sh
```
