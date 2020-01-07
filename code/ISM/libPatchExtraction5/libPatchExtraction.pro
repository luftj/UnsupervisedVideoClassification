######################################################################
# Automatically generated by qmake (1.07a) Fri Nov 5 10:49:29 2004
######################################################################

TEMPLATE = lib
TARGET = PatchExtraction5
#CONFIG += release
CONFIG += debug
VERSION = 2.21.0

QMAKE_CXXFLAGS_RELEASE = -O3

CODE = ../code

INCLUDEPATH += . $${CODE}/include

# Input
HEADERS += featurecue.hh featuregui.hh
SOURCES += featurecue.cc featuregui.cc 

# Binaries
BINARIES = salient.ln ibr.ln mser.ln h_affine.ln ebr.ln compute_descriptors.ln compute_descriptors2.ln compute_descriptors3.ln surf.ln surf64.ln surf128.ln

# make install
target.path = $${CODE}/lib/i686
headers.path = $${CODE}/include
headers.files = $${HEADERS}
binaries.path = $${CODE}/bin/i686
binaries.files = $${BINARIES}
INSTALLS += target headers binaries


