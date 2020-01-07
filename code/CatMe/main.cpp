/*
 * reads ISM detection results files and calculates, "similarity" of two detectors
 * Usage: CatMe <path_to_outputs> <detector> <sequence> <object> <IoU treshold>
 * for calculating similarity between detector and baseline, i.e. sequence_object-sequence_object
 * or
 * CatMe <detection_results_file> <baseline_results_file> <detector> <sequence> <object> <treshold>
 * when results files are known.
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
 * 
 * Use of our programs and files is made available for non-commercial purposes.
*/

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <cmath>

using namespace std;

struct Line
{
	int frameidx, objidx, xpos, ypos, width, height;
	float scale;
};

// read a line from the results.txt with schema provided by ISM
Line readLine(fstream& fs)
{
	Line ret;
	int spacer;
	fs >> ret.frameidx 
		>> ret.objidx 
		>> ret.xpos 
		>> ret.ypos 
		>> ret.scale
		>> spacer >> spacer >> spacer // skip the next entries: cat, left bbox and top bbox
		>> ret.width
		>> ret.height;
	fs.ignore(128,'\n'); // discard remainder of line

	return ret;
}

// calculate the Jaccars index (Intersection over Union) for two bounding boxes
float jaccard(int x0, int y0, int w0, int h0, int x1, int y1, int w1, int h1)
{
	int interw, interh;

	if(x0 < x1) interw = x0 + w0 - x1; // boundary conditions -> relation of bbox positions
	else        interw = x1 + w1 - x0;
	if(y0 < y1) interh = y0 + h0 - y1;
	else        interh = y1 + h1 - y0;

	int I = interw * interh;		// intersection of bboxes
	int U = w0 * h0 + w1 * h1 - I;	// union of bboxes

	if(!U || U < 0 || I < 0) return 0.f;

	return I/(float)U;	// IoU
}

// compare two bboxes specified by lines with given threshold, returns true if threshold is reached
bool compareObjects(Line a, Line b, float thresh)
{
	float iou = jaccard(a.xpos, a.ypos, a.width, a.height, b.xpos, b.ypos, b.width, b.height);
	
	return iou >= thresh;
}

// reads ISM detection results files and calculates, "similarity" of two detectors
// main function. Do all the file handling and processing here
int main(int argc, char* argv[]) 
{
	if (argc < 6)
	{
	    cerr << "Usage: CatMe <path_to_outputs> <detector> <sequence> <object> <treshold>" << endl;//[<object2...>]" << endl;
	    cerr << "Usage: CatMe <detection_results_file> <baseline_results_file> <detector> <sequence> <object> <treshold>" << endl;
	    return -1;
	}

	string detectorResults;
	string baselineResults;
	float tresh;
	string detector;
	string sequence;
	string object;

	if(argc == 6)
	{
		string filepath = argv[1];
		detector = argv[2];
		sequence = argv[3];
		object = argv[4];
		tresh = strtof(argv[5], nullptr); // change to char pointer, when more arguments needed

		detectorResults = filepath + detector + "-" + sequence + "_" + object + "/results.txt";
		baselineResults = filepath + sequence + "_" + object + "-" + sequence + "_" + object + "/results.txt";
	}
	else
	{
		detectorResults = argv[1];
		baselineResults = argv[2];
		detector = argv[3];
		sequence = argv[4];
		object = argv[5];
		tresh = strtof(argv[6], nullptr); // change to char pointer, when more arguments needed
	}

	fstream fs;

	vector<Line> detRes; // stores found objects
	fs.open(detectorResults); // todo: allow both figure-only and whole sequence ( _$object)
	fs.peek();
	while(fs.good())
		detRes.push_back(readLine(fs));
	fs.close();
	if(detRes.size() == 0)
		cerr << "Warning: empty detector results for " << detector << endl;

	vector<Line> objRes;
	fs.open(baselineResults); // todo: allow both figure-only and whole sequence (second _$object)
	fs.peek();
	while(fs.good())
		objRes.push_back(readLine(fs));
	fs.close();
	if(objRes.size() == 0)
		cerr << "Warning: empty object results for " << sequence << "_" << object << endl;

	cout << detector  << " " << sequence + "_" + object << " ";

	// results file lines are filled as follows:
	// [0] = frameidx
	// [1] = objidx
	// [2] = xpos
	// [3] = ypos
	// [4] scale
	// [5] cat
	// [6] left bbox
	// [7] top bbox
	// [8] width bbox
	// [9] height bbox
	// [10] score singlehypo
	// [11] mdl score?
	// following: 3D info when using camera calibration

	int score = 0;

	int detIt = 0;
	int objIt = 0;
	int resetIdx = -1;
	while(1)
	{
		if(detIt >= detRes.size() || objIt >= objRes.size())
			break;		// EOF

		if(detRes[detIt].frameidx > objRes[objIt].frameidx) // baseline has more detections for  frame
		{
			++objIt;	// skip detection
			continue;
		}
		if(detRes[detIt].frameidx < objRes[objIt].frameidx) // detector has more detections for frame
		{
			++detIt;	// skip detection
			continue;
		}

		// same frame, same detection: compare bounding boxes
		//cout << detRes[detIt].frameidx << " " << detRes[detIt].objidx << " --- " << objRes[objIt].frameidx << " " << objRes[objIt].objidx << endl;
		if(compareObjects(detRes[detIt], objRes[objIt], tresh))
			++score;

		// check for next objects
		// already iterating combinations
		if( resetIdx != -1)
		{
			// done
			if( detRes[detIt + 1].objidx == 0 && objRes[objIt + 1].objidx == 0 )
			{
				resetIdx = -1;
				++detIt;
				++objIt;
			}
			// iterate obj
			else if( objRes[objIt + 1].objidx != 0 )
			{
				++objIt;
			}
			// iterate det
			else if( objRes[objIt + 1].objidx == 0 )
			{
				++detIt;
				objIt = resetIdx;
			}
		}
		else // not iterating combinations
		{
			// both 0 -> iterate both (still could be different frames)
			if( detRes[detIt + 1].objidx == 0 && objRes[objIt + 1].objidx == 0 )
			{
				++detIt;
				++objIt;
			}
			// one has multiple objects -> iterate only one
			else if( detRes[detIt + 1].objidx > objRes[objIt + 1].objidx)
			{
				++detIt;
			}
			else if( detRes[detIt + 1].objidx < objRes[objIt + 1].objidx)
			{
				++objIt;
			}
			// both have multiple objects ->  try every combination
			else
			{
				resetIdx = objIt;
				++objIt; // iterare this one first
			}
		}
	}

	//cout << "score: " << score << endl;

	// normalise by #frames in baseline, since object needn't be visible in the whole sequence (prior probability)
	float normScore;
	if( objRes.size() == 0 )
		normScore = 0;
	else
		normScore = score / (float)objRes.size();
	cout << score << " " << normScore << endl;

	return 0; // no errors
}
