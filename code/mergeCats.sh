#!/bin/fish

# this script compares all output training detections, fetches their similarities with ./CatMe/CatMe 
# and merges codebooks if necessary with ./combineDetectors.sh


set mergeTresh $argv[1]	# similarity threshold: quotient of frames matched needed for category merge. default: 0.15
set simTresh $argv[2] 	# IoU score needed for "good" match. Default: 0.5

echo "Candidate detectors for merging:"

if test -e data/output/training/mergelist.txt
	rm data/output/training/mergelist.txt
end
touch data/output/training/mergelist.txt

for detector in (less files/codebooks/detectors.txt) # consider all detectors

	set detobjid (echo $detector | sed 's/.*_//') # only relevant for first iteration, naive bg-removal
	if test $detobjid -eq 0
		continue
	end

	for sequence in (less data/input/frames/sequences.txt) # all sequences
		for object in (find files/codebooks/ -maxdepth 1 -name "$sequence\_*" -not -name "*-*")
			set object (basename $object)
			
			set objid (echo $object | sed 's/.*_//')
			if test $objid -eq 0
				continue
			end

			set combobj (less files/codebooks/detectors.txt | grep $object )
			set requiredobjects (echo $combobj  | string split "-")

			if test (count $requiredobjects) -le 1 
				# matching with single sequences
			
				# calulate matched frames and similarity
				set output ( ./CatMe/CatMe data/output/training/ $detector $sequence $objid $simTresh ^ /dev/null | string split " ")
				# output: 1: detector 2: sequence 3: framesMatched 4: similarity
				
				if test (echo "$output[4] > 0" | bc) -eq 1 # don't log zero similarity
					echo $output
				end
				if test (echo "$output[4] >= $mergeTresh" | bc) -eq 1 # check against threshold
					if test $output[1] = $output[2] # don't compare to itself
						continue
					end
					echo $output >> data/output/training/mergelist.txt
				end
				#detecting sequence the detector was trained on should result in a score of 1.0

			else # matching with sequences, which have already been merged to stronger detectors
				if test $detector = $combobj
					continue
				end
				set sum 0
				set framesum 0
				for ro in $requiredobjects
					if test $detector = $ro
						set sum 0
						break
					end
					set roid (echo $ro | sed 's/.*_//')
					set ro (echo $ro | sed "s/_$roid//")
					
					# calulate matched frames and similarity
					set output ( ./CatMe/CatMe data/output/training/ $detector $ro $roid $simTresh  | string split " ")
					# output: 1: detector 2: sequence 3: # frames matched 4: % similarity

					if test $output[1] = $output[2] # don't compare to itself
						continue
					end
					set sum (echo "$sum + $output[4]" | bc)
					set framesum (echo "$framesum + $output[3]" | bc)
					if test (echo "$output[4] > 0" | bc) -eq 1 # check against threshold
						echo $output
					end
				end
				set sum (echo "$sum/ "(count $requiredobjects) | bc -l) # normalise by number of sequences, when combination score of multiple sequences
				
				if test (echo "$sum >= $mergeTresh" | bc) -eq 1 # check against threshold
					echo $detector $combobj $framesum $sum >> data/output/training/mergelist.txt
				end
			end
		end
	end
end


set sorted (sort -k4 -r data/output/training/mergelist.txt) # sort merge candidates by similarity
if test -e data/output/training/mergeHappened
	rm data/output/training/mergeHappened
end

echo $sorted


for line in $sorted # merge all detectors above similarity threshold
	set pair (string split " " $line)
	
	set skip 0
	for m in $merged
		# check if we have merged this candidate already
		if test $pair[1] = $m
		or test $pair[2] = $m
			set skip 1
			break
		end
	end
	if test $skip -eq 1
		continue
	end

	# else: merge these two detectors!
	echo "Merging detectors" $pair[1] $pair[2]
	./combineDetectors.sh $pair[1] $pair[2] # also adds new detector to files/codebooks/detectors.txt
	set merged $merged $pair[1] $pair[2]

	# remove old detectors from files/codebooks/detectors.txt
	sed -i -e "/^"$pair[1]"\$/d" -e "/^"$pair[2]"\$/d" files/codebooks/detectors.txt 

	# signals something was merged, when nothing is merged, we can terminate training
	touch data/output/training/mergeHappened 
end
