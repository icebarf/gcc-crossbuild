
target=$1
echo "Building cross compiler for: $target"

BIN_VER=2.37
GCC_VER=11.2.0

wget "https://ftp.gnu.org/gnu/binutils/binutils-$BIN_VER.tar.xz"
tar -xvf "binutils-$BIN_VER.tar.xz"

mkdir $HOME/out
export TARGET="$target"
export PREFIX="$HOME/out"
export PATH="$PATH":"$PREFIX/bin"

mkdir build-bins
cd build-bins
../binutils-$BIN_VER/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror --disable-debuginfod --disable-libdebuginfod
make -j 8
make install
cd ../


wget "https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VER/gcc-$GCC_VER.tar.xz"
tar -xvf "gcc-$GCC_VER.tar.xz"

if [ "$target" = "x86_64-elf" ]; then
    cp no-red-zone/t-x86_64-elf gcc-11.2.0/gcc/config/i386
    cp no-red-zone/11.2.0/config.gcc gcc-11.2.0/gcc/config.gcc
fi

mkdir build-gcc
cd build-gcc
../gcc-$GCC_VER/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers --with-newlib
make -j 8 all-gcc
make -j 8 all-target-libgcc
make -j 8 install-gcc
make -j 8 install-target-libgcc
cd ../

NLIB_VER=4.2.0.20211231
curl "https://sourceware.org/pub/newlib/newlib-$NLIB_VER.tar.gz" -o newlib
tar -xvf newlib
mkdir build-nl
cd build-nl
../newlib-$NLIB_VER/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install
cd ../

cd build-gcc
make -j 8 all-target-libstdc++-v3
make install-target-libstdc++-v3
cd ../

GDB_VER=11.1
wget https://ftp.gnu.org/gnu/gdb/gdb-$GDB_VER.tar.xz
tar -xvf gdb-$GDB_VER.tar.xz
mkdir build-gdb && cd build-gdb
../gdb-$GDB_VER/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --disable-werror
make -j8
make install
cd ../

echo "Finished building..."


