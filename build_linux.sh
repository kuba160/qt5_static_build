#!/bin/sh
set -x
export VERSION=5.15.2
export QT_GIT=git://code.qt.io/qt/qt5.git
export BUILD_DIR="qt5-build"
export OUTPUT_DIR="output"

git clone -b $VERSION --single-branch $QT_GIT 	;true
cd qt5; git submodule update --init --recursive ;true

mkdir -p "$BUILD_DIR"

cd "$BUILD_DIR"; ../qt5/configure -confirm-license \
	-opensource -nomake examples -nomake tests -static \
	-prefix         $BUILD_DIR \
    -sysconfdir     /etc/xdg   \
    -dbus-linked               \
    -openssl-linked            \
    -system-harfbuzz           \
    -system-sqlite             \
    -no-rpath                  \
    -skip qtwebengine

make -C "$BUILD_DIR"
make install
zip -r qt_$VERSION_static_linux.zip
