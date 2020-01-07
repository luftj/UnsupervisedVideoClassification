#!/bin/fish

# this script takes a list of detectors and provides a new detector, trained on all constituent codebooks
# output detector will be listed in files/codebooks/detectors.txt so make sure old ones are deleted first

set detectors $argv # list of all detectors to be merged

echo $detectors

# find cues, i.e. constituent codebooks
for d in $detectors
	for cue in (less files/codebooks/$d/cues.txt | string split "-")
		set cues $cues $cue
	end
end

# find detector input
for cue in $cues
	set files $files files/codebooks/$cue/$cue-no1pc.flz
	set files $files files/codebooks/$cue/$cue-no1pc_occ.flz
	set sequence $sequence $cue
end

set sequence (echo $sequence | sed 's/ /-/g')

mkdir files/codebooks/$sequence # output dir
touch files/codebooks/$sequence/cues.txt

rm files/$sequence.idl
touch files/$sequence.idl

for cue in $cues
	echo $cue >> files/codebooks/$sequence/cues.txt

	# create combined idl-file
	cat files/$cue.idl >> files/$sequence.idl
end

echo "Clustering " $sequence
./ISM/clusterer9/clusterer -nw -v -p files/cars.params -idl files/$sequence.idl -o files/codebooks/$sequence/$sequence #attention! -p BEFORE -idl! (otherwise figure area only param won't have effect)

echo "Creating occurence files for sequence" $sequence
./ISM/scmatcher9/scmatcher -co files/codebooks/$sequence/$sequence-no1pc.flz files/$sequence.idl files/codebooks/$sequence/$sequence-no1pc_occ.flz

echo "Creating detector file for sequence" $sequence
./ISM/mcmatcher3/mcmatcher -nw -v -cd files/codebooks/$sequence/$sequence.det files/codebooks/$sequence/$sequence-no1pc.flz files/codebooks/$sequence/$sequence-no1pc_occ.flz

echo $sequence >> files/codebooks/detectors.txt