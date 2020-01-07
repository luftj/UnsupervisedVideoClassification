#!/bin/fish

# use this script for testing. Uses one detector and runs test detections on all sequences

set detector $argv[1] # detector to use for test detections

for sequence in (less data/input/frames/sequences.txt)
	./detect.sh $detector $sequence 400 # run test detection on sequence. $1: mdl thresh
end