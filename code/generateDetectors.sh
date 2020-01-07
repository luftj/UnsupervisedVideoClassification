#!/bin/fish

# this script creates detector files for every codebook with occurences
#
# uses Bastian Leibe and Bernt Schiele,                    
# Bastian Leibe, Ales Leonardis and Bernt Schiele,                    
# Robust Object Detection with Interleaved Categorization and Segmentation
# In International Journal of Computer Vision, Vol.77, No. 1-3, May 2008.
# and
# Bastian Leibe, Krystian Mikolajczyk, and Bernt Schiele,
# Segmentation-Based Multi-Cue Integration for Object Detection
# In British Machine Vision Conference (BMVC'06), 2006.
#
# for usage of ./ISM/mcmatcher3/mcmatcher please consider ./ISM/mcmatcher3/readme.txt
# -cd argument implemented by us for CLI batch processing.

if test -e files/codebooks/detectors.txt
	rm files/codebooks/detectors.txt
end
touch files/codebooks/detectors.txt

for sequence in (ls -1 -d  files/codebooks/*/)
	set sequence (basename $sequence)
	echo $sequence

	if test -e files/codebooks/$sequence/$sequence.det
		echo $sequence >> files/codebooks/detectors.txt
		continue
	end
	if test -e files/codebooks/$sequence/$sequence-no1pc_occ.flz
		echo "Creating detector file for sequence" $sequence

		./ISM/mcmatcher3/mcmatcher -nw -vv -cd files/codebooks/$sequence/$sequence.det files/codebooks/$sequence/$sequence-no1pc.flz files/codebooks/$sequence/$sequence-no1pc_occ.flz
		
		echo $sequence >> files/codebooks/detectors.txt
	end
end