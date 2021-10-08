#!/bin/bash
git submodule init
git submodule update

# Make output
if [ ! -d build ]; then
	mkdir build
fi
if [ ! -d bin ]; then
	mkdir bin
else
	rm -rf bin
	mkdir bin
fi

# Get path
cd build
PWD=$(pwd)

# Build libusb
rm -rf ./*
cd $PWD/../libusb
./bootstrap.sh
cd -
$PWD/../libusb/configure -prefix=$PWD/../bin --enable-udev=no
make
make install

# Build libconfuse
rm -rf ./*
cd $PWD/../libconfuse
./autogen.sh
cd -
$PWD/../libconfuse/configure -prefix=$PWD/../bin
make
make install

# Build libftdi
rm -rf ./*
cmake -DCMAKE_INSTALL_PREFIX=$PWD/../bin $PWD/../libftdi/
make
make install

# Build libmpsse
rm -rf
