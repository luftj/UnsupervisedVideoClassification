#include <iostream>
#include <string>
#include <vector>

#include <boost/filesystem.hpp>

#include <opencv2/opencv.hpp>
#include <opencv2/core.hpp>
#include "opencv2/imgcodecs.hpp"
#include "opencv2/highgui.hpp"
#include "opencv2/imgproc.hpp"

using namespace std;
namespace fs = boost::filesystem;
using namespace cv;


class ExSeg
{
public:
	void openWD(string path, string sequence);
	void process(string ext);

private:
	string workingDir, sequence;
	vector<Mat> masks;
	Mat img;
	vector<Vec3b> objectidentitymap;

	void processFrame(string filename);
	void loadImage(string filepath);
	void saveMask();
	void findColours();
	int colourLookup(Vec3b colour);
};