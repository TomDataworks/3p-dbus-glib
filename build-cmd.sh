#!/bin/bash

cd "$(dirname "$0")"

# turn on verbose debugging output for parabuild logs.
set -x
# make errors fatal
set -e

PROJECT="dbus-glib"
VERSION="0.92"
SOURCE_DIR="$PROJECT-$VERSION"

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
pushd "$SOURCE_DIR"
    case "$AUTOBUILD_PLATFORM" in
        "windows")
			echo "dbus-glib headers only for linux"
        ;;
        "darwin")
			echo "dbus-glib headers only for linux"
        ;;
        "linux")
			# copy just the headers to the right place
			mkdir -p "$stage/include/dbus"
			cp -dp dbus/*.h "$stage/include/dbus"
        ;;
    esac
    mkdir -p "$stage/LICENSES"
    tail -n 31 COPYING > "$stage/LICENSES/$PROJECT.txt"
popd

pass

