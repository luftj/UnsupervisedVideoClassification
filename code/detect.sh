#!/bin/fish

# this script runs a test detection with a given detector on a given single sequence

set detector $argv[1] # detector to use
set sequence $argv[2] # sequence to test
set mdlThresh $argv[3] # minimum description lenght thrashold for hypotheses refinement. Higher means more restrictive -> less detections.

set outdir data/output/detection/$detector-$sequence # output directory

if test -d $outdir 
	echo "This task was already completed."
	exit
end

echo "Running detection of" $detector "on" $sequence

mkdir $outdir
touch $outdir/stdout.txt
touch $outdir/stderr.txt

# set parameters here
./changeDetectorParam.sh ObjWidth 200
./changeDetectorParam.sh ObjHeight 80
./changeDetectorParam.sh MinPFig 650 # default: 400
./changeDetectorParam.sh MinVoteWeight 0.0001
./changeDetectorParam.sh ScoreThreshSingle 1.1 # default: 1.5
./changeDetectorParam.sh  RecoScaleMin 0.1
./changeDetectorParam.sh  RecoScaleMax 1.5
./changeDetectorParam.sh  SearchRange 0.2
./changeDetectorParam.sh  ProcessBothDir 1

# do the magic
if test $mdlThresh -eq 0
	./ISM/mcmatcher3/mcmatcher -nw -vv -det files/codebooks/$detector/$detector.det -odir $outdir -idl files/$sequence.idl -nomdl > $outdir/stdout.txt 2> $outdir/stderr.txt 
else	
	./ISM/mcmatcher3/mcmatcher -nw -vv -det files/codebooks/$detector/$detector.det -odir $outdir -idl files/$sequence.idl -t $mdlThresh > $outdir/stdout.txt 2> $outdir/stderr.txt 
end

# you can reset them if you don't want to wite down the default values
./changeDetectorParam.sh ObjWidth 100
./changeDetectorParam.sh ObjHeight 40
./changeDetectorParam.sh MinPFig 400
./changeDetectorParam.sh MinVoteWeight 0.0002
./changeDetectorParam.sh ScoreThreshSingle 1.5
./changeDetectorParam.sh  RecoScaleMin 0.3
./changeDetectorParam.sh  RecoScaleMax 1.5
./changeDetectorParam.sh  SearchRange 0.25
./changeDetectorParam.sh  ProcessBothDir 1