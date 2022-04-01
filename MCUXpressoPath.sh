#!/bin/bash
#
# Script to set the PATH so that tools can be run from the command line
# Copyright 2018 NXP
#
# To set the path effectively, you must 'source' this script.
#

START_DIR=`pwd`
SCRIPT_PATH="${BASH_SOURCE[0]}";
while([ -L "${SCRIPT_PATH}" ]); do
    cd "`dirname "${SCRIPT_PATH}"`"
    SCRIPT_PATH="$(readlink "`basename "${SCRIPT_PATH}"`")";
done
cd "`dirname "${SCRIPT_PATH}"`" > /dev/null
SCRIPT_PATH="`pwd`";
PLUGIN_HOME="$SCRIPT_PATH"/ide/plugins
cd $START_DIR

# echo "Pluginhome: " $PLUGIN_HOME
# echo "StartDir: " $START_DIR

UNAME_RESULT="$(uname -s)"
case "${UNAME_RESULT}" in
    Linux*)     PLATFORM=linux;;
    Darwin*)    PLATFORM=macosx;;
    *)          PLATFORM=win32
esac

# echo "Platform: "$PLATFORM

latest_plugin () {
    pushd "$PLUGIN_HOME" > /dev/null
    curmajor=0
    curminor=0
    curservice=0
    curbuild=0
#   echo "argument " $1
    for d in $1; do
        if [ ! -d $d ] ; then
            echo "Cannot find plugin directory matching pattern $1"
            exit 1
        fi

        major=`expr $d :   '.*_\([0-9]*\).*'`
        minor=`expr $d :   '.*_[0-9]*\.\([0-9]*\).*'`
        service=`expr $d : '.*_[0-9]*\.[0-9]*\.\([0-9]*\).*'`
        build=`expr $d :   '.*_[0-9]*\.[0-9]*\.[0-9]*\.\([0-9]*\).*'`

        if [ $major -gt $curmajor ]; then
            curmajor=$major
            curminor=$minor
            curservice=$service
            curbuild=$build
            plugindir="$d"
        fi

        if [ $minor -gt $curminor ]; then
            curminor=$minor
            curservice=$service
            curbuild=$build
            plugindir="$d"
        fi

        if [ $service -gt $curservice ]; then
            curservice=$service
            curbuild=$build
            plugindir="$d"
        fi

        if [ $build -gt $curbuild ]; then
            curbuild=$build
            plugindir="$d"
        fi

    done
    popd > /dev/null

#    echo "plugindir :" $plugindir

    if [ ! -d "$PLUGIN_HOME/"$plugindir ] ; then
        echo "Cannot find plugin directory matching pattern $1"
        exit 1
    fi
}

latest_plugin com.nxp.mcuxpresso.tools.${PLATFORM}_*
export PATH="$PLUGIN_HOME/"$plugindir/tools/bin:$PATH

latest_plugin com.nxp.mcuxpresso.tools.bin.${PLATFORM}_*
export PATH="$PLUGIN_HOME/"$plugindir/binaries:$PATH

echo "Set PATH to $PATH"
