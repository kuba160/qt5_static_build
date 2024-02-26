#!/bin/sh
set -x
export VERSION=6.6.2
export QT_GIT=git://code.qt.io/qt/qt5.git
export MAIN_DIR="`pwd`"
export OUTPUT_DIR="/opt/qt5_static"

# python fix
ln -s /usr/bin/python3 /usr/bin/python

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
    -system-harfbuzz        \
    -system-sqlite          \
    -qt-doubleconversion    \
    -qt-pcre                \
    -qt-tiff                \
    -no-rpath               \
    -no-icu                 \
    -skip qtwebengine       \
    -skip qt3d              \
    -skip qtquick3d         \
    -skip qtquick3dphysics  \
    -skip qtdatavis3d       \
    -skip qtmultimedia      \
    -skip qthttpserver      \
    -skip qtlanguageserver  \
    -skip qtpositioning     \
    -skip qtlocation        \
    -skip qtgraphs          \
    -skip qtspeech
    # -ccache

cmake --build . --parallel
cmake --install .

cp $MAIN_DIR"/qt.conf" $OUTPUT_DIR"/bin/qt.conf"

cd $OUTPUT_DIR/..
zip -r /"qt_$VERSION"_static_linux.zip `basename $OUTPUT_DIR`
