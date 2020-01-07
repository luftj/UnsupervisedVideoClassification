/*
 * extracts segmentation masks for every frame from a motion segmentation sequence
 * Usage: ExSeg <path_to_video/images> <sequence name> <file extension>
 * 
 * Digital hand-in supplementary to the thesis
 * -------------------------------------------------------
 * "Unsupervised learning of object categories from video"
 * -------------------------------------------------------
 * 
 * by Jonas Luft,
 * as a partial fulfilment of the degree of "Master of Science" at TU Berlin, 2018.
 * Contact the author at jonas@luft.de
 * 
 * Disclaimer
 * ----------
 * THIS CODE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
 * WARRANTIES. Use at your own risk.  
 * The program uses third-party libraries published under varying licenses: OpenCV and boost.
 * 
 * Use of our programs and files is made available for non-commercial purposes.
*/

#include <iostream>
#include <string>

#include "ExSeg.h"

using namespace std;

// main function. Do all the file handling here
int main(int argc, char** argv) 
{

	// will contain path to input image (taken from argv[1])
	string path, sequence, ext;

	// check if image path was defined
	if (argc != 4)
	{
	    cerr << "Usage: ExSeg <path_to_video/images> <sequence> <extension>" << endl;
	    return -1;
	}
	else
	{

	    path = argv[1];
	    sequence = argv[2];
	    ext = argv[3];
	}

	ExSeg extractor;
	extractor.openWD(path, sequence);	// file handling
	extractor.process(ext);				// do the magic

	return 0;
}
