######################################################################
# Automatically generated by qmake (1.06c) Thu Jun 3 15:42:26 2004
######################################################################

TEMPLATE = lib
TARGET = Histogram
VERSION = 2.1.2

CONFIG += debug
#CONFIG += release
QMAKE_CXXFLAGS_RELEASE = -O3 #-march=pentium4 -mfpmath=sse -mmmx

CODE = ../code

INCLUDEPATH += . $${CODE}/include

# Input
HEADERS += histogram.hh \
           visualhistogram.hh

SOURCES += histogram.cc \
           visualhistogram.cc


# make install
target.path = $${CODE}/lib/i686
headers.path = $${CODE}/include
headers.files = $${HEADERS}
INSTALLS += target headers
