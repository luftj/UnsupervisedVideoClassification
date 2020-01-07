/*
 * This class handles extraction of 1 bit figure masks out of coloured dense segmentation maps
 *  
*/

#include "ExSeg.h"

using namespace std;

// sets a working directory
void ExSeg::openWD(string path, string sequence)
{
	workingDir = path;
	this->sequence = sequence;
}

// load image as a matric
void ExSeg::loadImage(string filepath)
{
	img = imread(filepath, IMREAD_COLOR);

	findColours();
}

// call this function to start processing
// input: ext: file extensions to look for in the working directory
void ExSeg::process(string ext)
{
	fs::path path;
	path /= workingDir;
	path /= sequence;
    for(auto& p: fs::directory_iterator(path))
    {
        if(p.path().extension() == ext)
        {
        	std::cout << p.path() << '\n';
        	loadImage(p.path().string());
        	processFrame(p.path().stem().string());
        }
    }
}

// process a single image found in working directory
void ExSeg::processFrame(string filename)
{
	fs::create_directories("output/"+sequence); // make sure we know where to put our result

	Mat drawing;
	int fuzz = 1; // hopefully there's no antialiasing in the segmentation masks!

	// todo: detect BG
	for( uint i = 0; i < objectidentitymap.size(); ++i ) // try all previously found objects and set colour code
	{
		fs::create_directories("output/"+sequence+"/"+to_string(i));
		Vec3b lower = objectidentitymap[i]-Vec3b::all(fuzz);
		Vec3b upper = objectidentitymap[i]+Vec3b::all(fuzz);
		inRange(img,lower, upper, drawing); // extract region of image in current colour code
		
		if(sum(drawing)[0] == 0) // skip empty (all black) masks
			continue;
			
		imwrite("output/"+sequence+"/"+to_string(i)+"/"+filename+"-map.png", drawing);
	}
}

// store colour in the lookup table
int ExSeg::colourLookup(Vec3b colour)
{
	int objtype = -1;

	for(uint i = 0; i < objectidentitymap.size(); ++i)
	{
		// find colour in colourmap
		if(colour == objectidentitymap.at(i))
			objtype = i;
	}
	if( objtype == -1 )
	{
		// object not seen yet -> add to colourmap
		objectidentitymap.push_back(colour);
		objtype = objectidentitymap.size() - 1;
	}

	return objtype;
}

// find all occuring colours in the image and store them in the lookup table
void ExSeg::findColours()
{
	vector<Vec3b> colours;

	// accept only char type matrices
    CV_Assert(img.depth() == CV_8U);
    int channels = img.channels();
    int nRows = img.rows;
    int nCols = img.cols * channels;
    if (img.isContinuous())
    {
        nCols *= nRows;
        nRows = 1;
    }

    uchar* p;
    for( int i = 0; i < nRows; ++i)
    {
        p = img.ptr<uchar>(i);
        for ( int j = 0; j < nCols; j+=channels)
        {
            Vec3b cur(p[j],p[j+1],p[j+2]);
            colourLookup(cur);
        }
    }
}