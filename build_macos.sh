#!/bin/sh
set -x
export VERSION=6.5.2
export QT_GIT=git://code.qt.io/qt/qt5.git
export MAIN_DIR="`pwd`"
export OUTPUT_DIR="`pwd`/qt5/build/qt5_static"

# ninja
brew install ninja

# python fix
ln -s /usr/bin/python3 /usr/bin/python; true

git clone -b $VERSION --single-branch $QT_GIT; true
cd qt5;

perl init-repository --module-subset=default,-qtwebengine

mkdir build
cd build

../configure -confirm-license \
    -opensource -nomake examples -nomake tests -static \
    -release                \
    -prefix $OUTPUT_DIR     \
    -sysconfdir /etc/xdg    \
    -system-zlib            \
    -qt-libpng              \
    -qt-libjpeg             \
    -qt-freetype            \
    -qt-pcre                \
    -no-rpath               \
    -no-icu                 \
    -dbus-runtime           \
    -skip qtwebengine       \
    -skip qt3d              \
    -skip qtquick3d         \
    -skip qtquick3dphysics  \
    -skip qtdatavis3d       \
    -skip qtmultimedia      \
    -skip qthttpserver      \
    -skip qtlanguageserver  \
    -skip qtpositioning     \
    -skip qtlocation
    # missing iconv

cmake --build . --parallel
cmake --install .

cp $MAIN_DIR"/qt.conf" $OUTPUT_DIR"/bin/qt.conf"

cd $OUTPUT_DIR/..
zip -r "qt_$VERSION"_static_macos.zip `basename $OUTPUT_DIR`
