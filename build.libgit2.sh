#!/bin/bash

LIBGIT2SHA=`cat ./libgit2_hash.txt`
SHORTSHA=${LIBGIT2SHA:0:7}

if [[ -d external/libgit2/build ]]
then
    if [[ -n $(ls libgit2-${SHORTSHA}.*) ]]
    then
        exit 0
    fi
fi

rm -rf external/libgit2/build
mkdir external/libgit2/build
pushd external/libgit2/build

export _BINPATH=`pwd`

cmake -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo \
      -DBUILD_CLAR:BOOL=OFF \
      -DUSE_SSH=ON \
      -DENABLE_TRACE=ON \
      -DLIBGIT2_FILENAME=git2-$SHORTSHA \
      -DCMAKE_OSX_ARCHITECTURES="i386" \
      -DCMAKE_SKIP_RPATH=TRUE
      ..
cmake --build .

popd

OS=`uname`
ARCH=`uname -m`
 
if [ $OS == "Darwin" ]; then
	PKGPATH="./mac"
	LIBEXT="dylib"
else
	exit 0
fi

git rm $PKGPATH/*
mkdir -p $PKGPATH

cp external/libgit2/build/libgit2-$SHORTSHA.$LIBEXT $PKGPATH/

exit $?
