#!/bin/bash

cd /sass

rm -r resources/win32-x86
mkdir -p resources/win32-x86

# *** Build libsass

make -C native-src clean
cd native-src
git reset --hard # hard reset
git clean -xdf # hard clean
cd ..

# *** Prepare makefile to use static bindings
# static libgcc and libstdc++
sed -i 's/LDFLAGS  += -std=gnu++0x/LDFLAGS  += -std=gnu++0x -static-libgcc -static-libstdc++/' native-scr/Makefile
# static windows bindings
sed -i 's/ -Wl,--subsystem,windows/ -static -Wl,--subsystem,windows/' native-src/Makefile

MAKE=mingw32 \
CC=i686-w64-mingw32-gcc \
CXX=i686-w64-mingw32-g++ \
WINDRES=i686-w64-mingw32-windres \
BUILD=static \
    make -C native-src -j8 lib/libsass.dll || exit 1
cp native-src/lib/libsass.dll resources/win32-x86/sass.dll || exit 1

cd native-src
git reset --hard # hard reset
git clean -xdf # hard clean