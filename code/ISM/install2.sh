#!/bin/fish

# Create a directory tree for the image libraries
mkdir -p code
mkdir -p code/bin
mkdir -p code/bin/i686
mkdir -p code/include
mkdir -p code/lib
mkdir -p code/lib/i686
mkdir -p code/obj
mkdir -p code/obj/i686

#
# Set the library path
#

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:code/lib/i686"
export QTDIR=/usr/share/qt3


#
# Compile the directories individually
#

./compile.sh