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
if [ $? -ne 0 ]; then
	echo -e "\n\e[31mlibusb build failed.\e[0m\n"
	exit
else
	echo -e "\n\e[32mlibusb build succeed.\e[0m\n"
fi
echo "----------------------------------------"

# Build libconfuse
rm -rf ./*
cd $PWD/../libconfuse
./autogen.sh
cd -
$PWD/../libconfuse/configure -prefix=$PWD/../bin
make
make install
if [ $? -ne 0 ]; then
	echo -e "\n\e[31mlibconfuse build failed.\e[0m\n"
	exit
else
	echo -e "\n\e[32mlibconfuse build succeed.\e[0m\n"
fi
echo "----------------------------------------"

# Build libftdi
rm -rf ./*
cmake -DCMAKE_INSTALL_PREFIX=$PWD/../bin $PWD/../libftdi/
make
make install
if [ $? -ne 0 ]; then
	echo -e "\n\e[31mlibftdi build failed.\e[0m\n"
	exit
else
	echo -e "\n\e[32mlibftdi build succeed.\e[0m\n"
fi
echo "----------------------------------------"

# Build libmpsse
rm -rf ./*
cd $PWD/../src
./bootstrap.sh
cd -
$PWD/../src/configure --disable-python --enable-static --disable-shared --prefix=$PWD/../bin CFLAGS="-I$PWD/../bin/include -I$PWD/../bin/include/libftdi1 -I$PWD/../bin/include/libusb-1.0" LDFLAGS="-L$PWD/../bin/lib $PWD/../bin/lib/*.a"
make SUBDIRS=""
make install
make
if [ $? -ne 0 ]; then
	echo -e "\n\e[31mlibmpsse build failed.\e[0m\n"
	exit
else
	echo -e "\n\e[32mlibmpsse build succeed.\e[0m\n"
fi
echo "----------------------------------------"

echo -e "\n\e[32mAll Finish.\e[0m\n"