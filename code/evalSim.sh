#!/bin/fish

# this script takes the test detection results of a detector and calculates all similarities to the baseline (training) detections.
# requires test detection results in data/output/detection/$detector-$sequence/results.txt
# and baseline detection results in data/output/training/$detector-$sequence\_$object/results.txt
# outputs a file data/output/detection/1eval_$detector.txt with detection scores.

set detector $argv[1] 	# detector to use
set simTresh $argv[2] 	# IoU score needed for "good" match. Default 0.5

rm data/output/detection/1eval_$detector.txt
touch data/output/detection/1eval_$detector.txt
echo $detector

for sequence in (less data/input/frames/sequences.txt) # every sequence
	set frames ( head -1 data/inter/tracking/OchsBroxMalik?_all_00000?0.00/$sequence/Tracks*) # number of frames in sequence
	
	for object in (find files/codebooks/ -maxdepth 1 -name "$sequence\_*" -not -name "*-*") # every object
		set object (basename $object)
		
		set objid (echo $object | sed 's/.*_//')
		if test $objid -eq 0
			continue
		end

		./renumResults.sh $sequence\_$objid $sequence $objid # when frames have been trimmed, this makes sure the relative output numbering translates to the absolute frame numbering

		# matching with single sequences only
		set detRes "data/output/detection/$detector-$sequence/results.txt"
		set baseRes "data/output/training/$sequence""_$objid-$sequence""_$objid/relresults.txt"
		set output ( ./CatMe/CatMe $detRes $baseRes $detector $sequence $objid $simTresh  ^ /dev/null | string split " ")

		if test (echo "$output[4] > 0" | bc) -eq 1 # don't care about zero similarity
			if test $output[1] = $output[2] 
				#continue # uncomment if you don't care about self-similarity
				#detecting sequence the detector was trained on should result in a score of 1.0
			end
			echo $output >> data/output/detection/1eval_$detector.txt
		end
	end
end

set sorted (sort -k4 -r data/output/detection/1eval_$detector.txt) # sort by similarity for convenience
rm data/output/detection/1eval_$detector.txt
touch data/output/detection/1eval_$detector.txt
for s in $sorted
	echo $s >> data/output/detection/1eval_$detector.txt
end