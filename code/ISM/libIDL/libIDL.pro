######################################################################
# Automatically generated by qmake (1.07a) Fri Jan 28 20:36:49 2005
######################################################################

TEMPLATE = lib
TARGET = IDL
#CONFIG += release
CONFIG += debug
VERSION = 1.3.5

QMAKE_CXXFLAGS_RELEASE = -O3

CODE = ../code

INCLUDEPATH += . $${CODE}/include

# Input
HEADERS += idlparser.hh imgdescr.hh imgdescrlist.hh
SOURCES += idlparser.cc imgdescrlist.cc

# make install
target.path = $${CODE}/lib/i686
headers.path = $${CODE}/include
headers.files = $${HEADERS}
INSTALLS += target headers
