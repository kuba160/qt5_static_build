#!/bin/sh
set -x
export VERSION=5.15.2
export QT_GIT=git://code.qt.io/qt/qt5.git
export OUTPUT_DIR="qt5_static"

git clone -b $VERSION --single-branch $QT_GIT   ;true
perl qt5/init-repository --module-subset=default,-qtwebengine
cd qt5; git submodule update --init --recursive ;true

qt5/configure -confirm-license \
    -opensource -nomake examples -nomake tests -static \
    -prefix $OUTPUT_DIR     \
    -sysconfdir /etc/xdg    \
    -dbus-linked            \
    -openssl-linked         \
    -system-harfbuzz        \
    -system-sqlite          \
    -no-rpath               \
    -skip qtwebengine

make
make install
zip -r qt_$VERSION_static_linux.zip qt5_qtatic
