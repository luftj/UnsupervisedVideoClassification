#!/bin/fish

# runs detection with every codebook in files/codebooks/detectors.txt on every sequence in data/input/frames/sequences.txt
# output in data/output/training
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

set mdlThresh $argv[1] # minimum description length threshold for refining conflicting hypotheses. Default: 400. Higher means more restrictive -> less detections

for detector in (less files/codebooks/detectors.txt)
	set detector (basename $detector .det)
	for sequence in (less data/input/frames/sequences.txt)
		for object in (find files/codebooks/ -maxdepth 1 -name "$sequence\_*" -not -name "*-*") # makes sure not to run on empty sequences
			set object (basename $object)
			set object (echo $object | sed 's/.*_//')
			
			if test $object -eq 0
				continue
			end
			set outdir data/output/training/$detector-$sequence\_$object # output directory
			
			if test -d "$outdir"
					continue
			end

			echo "Running detection of" $detector "on" $sequence\_$object

			mkdir $outdir
			touch $outdir/stdout.txt # logs to file
			touch $outdir/stderr.txt

			# do the magic
			./ISM/mcmatcher3/mcmatcher -nw -vv -det files/codebooks/$detector/$detector.det -odir $outdir -idl files/$sequence\_$object.idl -t $mdlThresh > $outdir/stdout.txt 2> $outdir/stderr.txt 
			end
		end
end