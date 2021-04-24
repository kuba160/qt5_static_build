#!/bin/sh
set -x
export VERSION=5.12.10
export QT_GIT=git://code.qt.io/qt/qt5.git
export OUTPUT_DIR="/opt/qt5_static"

git clone -b $VERSION --single-branch $QT_GIT   ;true
cd qt5;

perl init-repository --module-subset=default,-qtwebengine

mkdir build
cd build

../configure -confirm-license \
    -opensource -nomake examples -nomake tests -static \
    -prefix $OUTPUT_DIR     \
    -sysconfdir /etc/xdg    \
    -dbus-linked            \
    -no-openssl	            \
    -qt-harfbuzz            \
    -system-sqlite          \
    -no-rpath               \
    -iconv                  \
    -no-icu                 \
    -skip qtwebengine

make
make install

cd $OUTPUT_DIR/..
zip -r /"qt_$VERSION"_static_linux.zip `basename $OUTPUT_DIR`
