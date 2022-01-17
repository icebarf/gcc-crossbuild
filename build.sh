# User configurable variables
BIN_VER=2.37
GCC_VER=11.2.0
GDB_VER=11.1
NLIB_VER=4.2.0.20211231
MAKEOPTS=8

target=$1
echo "Building cross compiler for: $target"

# Binutils
wget "https://ftp.gnu.org/gnu/binutils/binutils-$BIN_VER.tar.xz"
tar -xvf "binutils-$BIN_VER.tar.xz"

mkdir $HOME/out
export TARGET="$target"
export PREFIX="$HOME/out"
export PATH="$PATH":"$PREFIX/bin"

mkdir build-bins
cd build-bins
../binutils-$BIN_VER/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror --disable-debuginfod --disable-libdebuginfod
make $MAKEOPTS
make install
cd ../

# GCC
wget "https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VER/gcc-$GCC_VER.tar.xz"
tar -xvf "gcc-$GCC_VER.tar.xz"

if [ "$target" = "x86_64-elf" ]; then
    cp no-red-zone/t-x86_64-elf $GCC_VER/gcc/config/i386
    cp no-red-zone/$GCC_VER/config.gcc $GCC_VER/gcc/config.gcc
fi

mkdir build-gcc
cd build-gcc
../gcc-$GCC_VER/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers --with-newlib
make $MAKEOPTS all-gcc
make $MAKEOPTS all-target-libgcc
make $MAKEOPTS install-gcc
make $MAKEOPTS install-target-libgcc
cd ../

# Newlib
curl "https://sourceware.org/pub/newlib/newlib-$NLIB_VER.tar.gz" -o newlib
tar -xvf newlib
mkdir build-nl
cd build-nl
../newlib-$NLIB_VER/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make $MAKEOPTS
make install
cd ../

cd build-gcc
make $MAKEOPTS all-target-libstdc++-v3
make install-target-libstdc++-v3
cd ../

# GDB
wget https://ftp.gnu.org/gnu/gdb/gdb-$GDB_VER.tar.xz
tar -xvf gdb-$GDB_VER.tar.xz
mkdir build-gdb && cd build-gdb
../gdb-$GDB_VER/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --disable-werror
make $MAKEOPTS
make install
cd ../

echo "Finished building..."
