#!/bin/fish

# run training for all sequences in data/input/frames/sequences.txt

set iterations $argv[1] # max number of iterations, in case something goes wrong
#set user $argv[2] # username for access to remote for dense segmentation
#set pass $argv[3] # password for access to remote for dense segmentation
set user user
set pass password
set remote 127.0.0.1

set mosegsampling 8 # space density subsampling for motion segmentation
set mosegnu 60		# regularisation paramter for motion segmentation

./runMoSeg.sh $mosegsampling $mosegnu	# sparse motion segmentation
./runDensify.sh $titanUser $titanPass $mosegsampling $mosegnu $remote 	# dense motion segmentation. runs on remote via ssh
./runExSeg.sh 							# extract figure masks from dense seg
./prepareISMfiles.sh 					# trim frames withpout movement, make files readable for next steps
./runISM.sh								# train codebooks on single sequences
./createOccurences.sh 					# train occurence distribution of codebooks
./generateDetectors.sh 					# generate detector files
for i in (seq $iterations) 
	./changeDetectorParam.sh ObjWidth 200 # set detector parameters. ./ISM/mcmatcher3/readme.txt has some notes. See files/cars.params for identifiers, most relevant listed here. 
	./changeDetectorParam.sh ObjHeight 80
	./changeDetectorParam.sh MinPFig 625 # default 400
	./changeDetectorParam.sh ScoreThreshSingle 1.5 # default: 1.5
	./changeDetectorParam.sh MinVoteWeight 0.0002
	#./changeDetectorParam.sh  RecoScaleMin 0.3
	#./changeDetectorParam.sh  RecoScaleMax 1.5
	#./changeDetectorParam.sh  SearchRange 0.25
	./changeDetectorParam.sh  ProcessBothDir 1

	./runTrainingDetection.sh 400 # run detections with every codebook on every sequence. $1: MDL threshold for hypthesis refinement, defult 400
	touch data/output/training/mergeout_$i.txt
	./mergeCats.sh 0.15 0.5 >> data/output/training/mergeout_$i.txt # calculate similarity and merge codebooks, logs in file. $1: merge similarity threshold, default 0.15. $2: IoU match threshold, default 0.5

	if test -e data/output/training/mergeHappened
		continue
	else
		echo "Nothing merged - training is done! Iterations: $i"
		break
	end
end
