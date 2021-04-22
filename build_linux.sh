#!/bin/sh
set -x
export VERSION=5.15.2
export QT_GIT=git://code.qt.io/qt/qt5.git
export OUTPUT_DIR="qt5_static"

git clone -b $VERSION --single-branch $QT_GIT   ;true
cd qt5;

perl qt5/init-repository --module-subset=default,-qtwebengine
git submodule update --init --recursive ;true

mkdir build
cd build

../configure -confirm-license \
    -opensource -nomake examples -nomake tests -static \
    -prefix ~/$OUTPUT_DIR   \
    -sysconfdir /etc/xdg    \
    -dbus-linked            \
    -openssl-linked         \
    -system-harfbuzz        \
    -system-sqlite          \
    -no-rpath               \
    -skip qtwebengine

make
make install
zip -r qt_$VERSION_static_linux.zip ~/$OUTPUT_DIR
