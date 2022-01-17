# gcc-crossbuild
 C/C++ (binutils, newlib, libstdc++, gdb) cross compiler for x86_64, aarch64 and riscv64

[![Build GCC](https://github.com/sysfau1t/gcc-crossbuild/actions/workflows/build-gcc.yml/badge.svg)](https://github.com/sysfau1t/gcc-crossbuild/actions/workflows/build-gcc.yml)

# How to build
```sh
git clone https://github.com/sysfau1t/gcc-crossbuild
cd gcc-crossbuild
mkdir build
cd build
cp ../build.sh ./
cp -r ../no-red-zone/ ./ # only if you are building for x86_64 and you want to disable redzone
chmod +x build.sh
./build.sh [target] # for example: ./build.sh x86_64-elf
```

If you don't want to build it yourself, you can download pre-built binaries from [releases](https://github.com/sysfau1t/gcc-crossbuild/releases)


Patches/PRs are welcome to improve the script!

Happy Hacking!

# Configuration

There are user configurable variables to specify which version to build.
```sh
BIN_VER=2.37
GCC_VER=11.2.0
GDB_VER=11.1
NLIB_VER=4.2.0.20211231
CORES=8
```
- BIN_VER: Binutils Version to build
- GCC_VER: GCC Version to build
- GDB_VER: GDB Version to build
- NLIB_VER: Newlib Version to build
- CORES: Number of CPU Cores to parallelize jobs
