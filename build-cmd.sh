#!/bin/bash

cd "$(dirname "$0")"

# turn on verbose debugging output for parabuild logs.
set -x
# make errors fatal
set -e

PROJECT="dbus-glib"
VERSION="0.76"
SOURCE_DIR="$PROJECT-$VERSION"

DBUS_VERSION="1.2.1"
DBUS_SOURCE_DIR="dbus-$DBUS_VERSION"

if [ -z "$AUTOBUILD" ] ; then 
    fail
fi

if [ "$OSTYPE" = "cygwin" ] ; then
    export AUTOBUILD="$(cygpath -u $AUTOBUILD)"
fi

# load autbuild provided shell functions and variables
set +x
eval "$("$AUTOBUILD" source_environment)"
set -x

stage="$(pwd)/stage"

echo "${VERSION}" > "${stage}/VERSION.txt"

case "$AUTOBUILD_PLATFORM" in
    "linux")
        pushd "$SOURCE_DIR"
            # copy just the headers to the right place
            mkdir -p "$stage/include/dbus"
            cp -dp dbus/*.h "$stage/include/dbus"
        popd
        pushd "$DBUS_SOURCE_DIR"
            cp -dp dbus/*.h "$stage/include/dbus"
        popd
    ;;
    "linux64")
        pushd "$SOURCE_DIR"
            # copy just the headers to the right place
            mkdir -p "$stage/include/dbus"
            cp -dp dbus/*.h "$stage/include/dbus"
        popd
        pushd "$DBUS_SOURCE_DIR"
            cp -dp dbus/*.h "$stage/include/dbus"
        popd
    ;;
esac
mkdir -p "$stage/LICENSES"
tail -n 31 "$SOURCE_DIR/COPYING" > "$stage/LICENSES/$PROJECT.txt"

pass

