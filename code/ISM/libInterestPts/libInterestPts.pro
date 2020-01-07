######################################################################
# Automatically generated by qmake (1.07a) Fri Nov 5 10:49:29 2004
######################################################################

TEMPLATE = lib
TARGET = InterestPts
#CONFIG += release
CONFIG += debug
VERSION = 3.0.2

QMAKE_CXXFLAGS_RELEASE = -O3

CODE = ../code

INCLUDEPATH += . $${CODE}/include

# Input
HEADERS += applydetectors.hh \
	   dogscalespace.hh \
	   ophalapimage.hh \
	   opharrisimage.hh \
	   opinterestimage.hh \
	   oplindebergimage.hh \
	   polcoe.h

SOURCES += applydetectors.cc \
	   dogscalespace.cc \
	   ophalapimage.cc \
	   opharrisimage.cc \
	   opinterestimage.cc \
	   oplindebergimage.cc \
	   polcoe.cc \


# make install
target.path = $${CODE}/lib/i686
headers.path = $${CODE}/include
headers.files = applydetectors.hh dogscalespace.hh ophalapimage.hh opharrisimage.hh opinterestimage.hh oplindebergimage.hh polcoe.h
INSTALLS += target headers


