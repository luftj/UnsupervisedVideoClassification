#!/bin/fish

# this script calculates sparse motion segmentation for every sequence in data/input/frames/sequences.txt 
# using: Peter Ochs, Jitendra Malik, Thomas Brox 
# Segmentation of moving objects by long term video analysis
# IEEE Transactions on Pattern Analysis and Machine Intelligence, preprint, 2013. 
# for ./MotSeg/MoSeg usage refer to MotSeg/readme.txt

while read sequence
	if test -d "data/inter/tracking/OchsBroxMalik8_all_0000060.00/$sequence"
		continue
	end
	./MotSeg/MoSeg filestructureTrainingSet.cfg $sequence 0 (awk -F " " 'NR==1 {print $1}' data/input/frames/$sequence/$sequence.bmf) $argv[1] $argv[2]
end < data/input/frames/sequences.txt 
