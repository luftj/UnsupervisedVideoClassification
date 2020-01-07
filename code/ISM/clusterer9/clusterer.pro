######################################################################
# Automatically generated by qmake (1.07a) Fri Nov 5 10:09:33 2004
######################################################################

TEMPLATE = app
target = clusterer
#CONFIG += release
CONFIG += debug

QMAKE_CXXFLAGS_RELEASE = -O3 #-march=pentium4 -mfpmath=sse -mmmx

CODE = ../code

INCLUDEPATH += . $${CODE}/include

# Input
HEADERS += clusterer.hh \
           nrutil.h 

SOURCES += clusterer-interface.cc \
           clusterer.cc \
           main.cc \
           nrutil.c



QT_LIBS      = -lqt-mt -lQtTools
IMGDB_LIBS   = -lImgDB
#PCCV_LIBS    = -lrgbdisp 
IMAGE_LIBS   = -limage -lGrayImage -lRGBImage -lGaussDeriv -lCanny -lMorphology 
SCALE_LIBS   = -lScaleSpace -lInterestPts -lPatchExtraction5
FEATURE_LIBS = -lFeatures -lPCA -lMath -lMatrix -lChiSquare -lNNSearch -lCluster2 -lHistogram -lEdgeSIFT -lChamfer -lCodebook2
OTHER_LIBS     = -lHelpers -lIDL -lOrientationPlanes #-lewidgets
STD_LIBS     = -lm -lstdc++
LIBS += -L$${CODE}/lib/i686 $${QT_LIBS} $${IMAGE_LIBS} $${SCALE_LIBS} $${FEATURE_LIBS} $${OTHER_LIBS}

