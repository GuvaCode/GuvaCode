#!/bin/bash


read -p "install dependencies (y/n)? " answer
case ${answer:0:1} in y|Y )

sudo apt-get install mingw-w64-x86-64-dev
sudo apt-get install mingw-w64-i686-dev

sudo apt-get install gcc-mingw-w64-x86-64     
sudo apt-get install gcc-mingw-w64-i686
sudo apt-get install gcc-mingw-w64-i686-posix
sudo apt-get install gcc-mingw-w64-i686-win32
sudo apt-get install build-essential libc6-dev-i386
sudo apt-get install libgl1-mesa-dev:i386
    ;;
    * )
        echo skiping
    ;;
esac


clear

mkdir libs
mkdir libs/x86_64-linux
mkdir libs/x86_32-linux
mkdir libs/x86_64-windows
mkdir libs/x86_32-windows



echo "build raylib ...."
echo "build x64 linux ..."

cd raylib/src
make clean
make PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED RAYLIB_MODULE_RAYGUI=TRUE RAYLIB_MODULE_PHYSAC=TRUE

echo " copy libs x86_64-linux ..."

rm -f ../../libs/x86_64-linux/*
cp libraylib.so.5.0.0 ../../libs/x86_64-linux/libraylib.so

#ln -s /../../libs/x86_64-linux/libraylib.so.5.0.0 /../../libs/x86_64-linux/libraylib.so.500
#ln -s /../../libs/x86_64-linux/libraylib.so.500 /../../libs/x86_64-linux/libraylib.so

make clean

make PLATFORM=PLATFORM_DESKTOP RAYLIB_MODULE_RAYGUI=TRUE RAYLIB_MODULE_PHYSAC=TRUE
cp libraylib.a ../../libs/x86_64-linux


echo " build x86_32 linux ..."
### cd raylib/src
make clean
make PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED RAYLIB_MODULE_RAYGUI=TRUE RAYLIB_MODULE_PHYSAC=TRUE LDFLAG=-m32


echo " copy libs x86_32-linux ..."
rm -f ../../libs/x86_32-linux/*
cp libraylib.so.5.0.0 ../../libs/x86_32-linux/libraylib.so
#ln -s /../../libs/x86_32-linux/libraylib.so.5.0.0 /../../libs/x86_32-linux/libraylib.so.500
#ln -s /../../libs/x86_32-linux/libraylib.so.500 /../../libs/x86_32-linux/libraylib.so
make clean

make PLATFORM=PLATFORM_DESKTOP RAYLIB_MODULE_RAYGUI=TRUE RAYLIB_MODULE_PHYSAC=TRUE LDFLAG=-m32
cp libraylib.a ../../libs/x86_32-linux
#--------------------------------------------------------------------------------------------------------

make clean 
echo " build x64 windows ..."
cp ../../raygui/src/raygui.h raygui.c
cp ../../physac/src/physac.h physac.h

#### x86_64-w64-mingw32-windres

x86_64-w64-mingw32-windres raylib.rc -o raylib.rc.data
x86_64-w64-mingw32-windres raylib.dll.rc -o raylib.dll.rc.data

make PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED RAYLIB_MODULE_RAYGUI=TRUE RAYLIB_MODULE_PHYSAC=TRUE OS=Windows_NT CC=x86_64-w64-mingw32-gcc AR=x86_64-w64-mingw32-ar 

rm -f ../../libs/x86_64-windows/*
cp libraylibdll.a ../../libs/x86_64-windows
cp raylib.dll ../../libs/x86_64-windows


make clean
echo " build x32 windows ..."
cp ../../raygui/src/raygui.h raygui.c
cp ../../physac/src/physac.h physac.h

#### i686-w64-mingw32-windres

i686-w64-mingw32-windres raylib.rc -o raylib.rc.data
i686-w64-mingw32-windres raylib.dll.rc -o raylib.dll.rc.data

make PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED RAYLIB_MODULE_RAYGUI=TRUE RAYLIB_MODULE_PHYSAC=TRUE OS=Windows_NT CC=i686-w64-mingw32-gcc AR=i686-w64-mingw32-ar

rm -f ../../libs/x86_32-windows/*
cp libraylibdll.a ../../libs/x86_32-windows
cp raylib.dll ../../libs/x86_32-windows
#make clean

rm raygui.c
rm physac.h

echo "--------------------"
echo "| All done ..      |"
echo "--------------------"


