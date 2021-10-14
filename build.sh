#!/bin/bash
git submodule init
git submodule update

# Global Variable
CHECK_LIB_STATUS_SUCCEED=""

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
else
	echo -e "\n\e[32mlibusb build succeed.\e[0m\n"
	CHECK_LIB_STATUS_SUCCEED+="libusb"
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
else
	echo -e "\n\e[32mlibconfuse build succeed.\e[0m\n"
	CHECK_LIB_STATUS_SUCCEED+="libconfuse"
fi
echo "----------------------------------------"

# Build libftdi
rm -rf ./*
#set PKG_CONFIG_PATH $PWD/../../bin/lib/pkgconfig
cmake -DCMAKE_INSTALL_PREFIX=$PWD/../bin $PWD/../libftdi/
#cmake -DCMAKE_INSTALL_PREFIX="../bin/" .. -DLIBUSB_LIBRARIES=../../bin/lib -DLIBUSB_INCLUDE_DIR=../../bin/include/libusb-1.0/ -DCONFUSE_LIBRARY=../../bin/lib/ -DCONFUSE_INCLUDE_DIR=../../bin/include/

make
make install
if [ $? -ne 0 ]; then
	echo -e "\n\e[31mlibftdi build failed.\e[0m\n"
else
	echo -e "\n\e[32mlibftdi build succeed.\e[0m\n"
	CHECK_LIB_STATUS_SUCCEED+="libftdi"
fi
echo "----------------------------------------"

# Build libmpsse
rm -rf ./*
cd $PWD/../src
gcc -c *.c -I$PWD/../bin/include/libftdi1/ -static
ar -rcs libmpsse.a *.o
if [ $? -ne 0 ]; then
	echo -e "\n\e[31mlibmpsse build failed.\e[0m\n"
else
	echo -e "\n\e[32mlibmpsse build succeed.\e[0m\n"
	CHECK_LIB_STATUS_SUCCEED+="libmpsse"
	cp libmpsse.a $PWD/../bin/lib
	cp mpsse.h $PWD/../bin/include
fi
echo "----------------------------------------"

echo -e "\n\e[32mAll Finish.\e[0m\n"
if [[ "$CHECK_LIB_STATUS_SUCCEED" =~ "libusb" ]]; then
	echo -e "\e[32mlibusb build succeed.\e[0m"
else
	echo -e "\e[31mlibusb build failed.\e[0m"
fi
if [[ "$CHECK_LIB_STATUS_SUCCEED" =~ "libconfuse" ]]; then
	echo -e "\e[32mlibconfuse build succeed.\e[0m"
else
	echo -e "\e[31mlibconfuse build failed.\e[0m"
fi
if [[ "$CHECK_LIB_STATUS_SUCCEED" =~ "libftdi" ]]; then
	echo -e "\e[32mlibftdi build succeed.\e[0m"
else
	echo -e "\e[31mlibftdi build failed.\e[0m"
fi
if [[ "$CHECK_LIB_STATUS_SUCCEED" =~ "libmpsse" ]]; then
	echo -e "\e[32mlibmpsse build succeed.\e[0m"
else
	echo -e "\e[31mlibmpsse build failed.\e[0m"
fi
