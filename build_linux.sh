#!/bin/sh
set -x
export VERSION=6.5.2
export QT_GIT=git://code.qt.io/qt/qt5.git
export MAIN_DIR="`pwd`"
export OUTPUT_DIR="/opt/qt5_static"

# python fix
ln -s /usr/bin/python3 /usr/bin/python

git clone -b $VERSION --single-branch $QT_GIT   ;true
cd qt5;

perl init-repository --module-subset=essential,-qtdoc,-qttools,qtbase,qtcharts,qtdeclarative,qtimageformats,\
qtshadertools,qtsvg,qttranslations,qtvirtualkeyboard,qtwayland

mkdir build
cd build

../configure -confirm-license \
    -opensource -nomake examples -nomake tests -static \
    -release                \
    -optimize-size          \
    -prefix $OUTPUT_DIR     \
    -sysconfdir /etc/xdg    \
    -dbus-linked            \
    -no-openssl	            \
    -system-harfbuzz        \
    -system-sqlite          \
    -qt-doubleconversion    \
    -qt-libb2               \
    -qt-pcre                \
    -qt-libjpeg             \
    -qt-libpng              \
    -qt-libmd4c             \
    -no-rpath               \
    -no-icu                 \
    -no-tiff                \
    -no-webp                \
    -no-pch                 \
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
    -no-feature-androiddeployqt \
    -no-feature-http        \
    -no-feature-network     \
    -no-feature-sql         \
    -no-feature-sqlmodel    \
    -no-feature-wizard      \
    -no-feature-xmlstream

cmake --build . --parallel
cmake --install .

cp $MAIN_DIR"/qt.conf" $OUTPUT_DIR"/bin/qt.conf"

cd $OUTPUT_DIR/..
zip -r /"qt_$VERSION"_static_linux.zip `basename $OUTPUT_DIR`
