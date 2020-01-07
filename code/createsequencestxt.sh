#!/bin/fish

# run this script if you put sequences in data/input/frames and are to lazy to type their names into data/input/frames/sequences.txt for processing

pushd data/input/frames
touch sequences.txt

for sequence in (find . -maxdepth 1 -type d)
	set base (basename $sequence)
	if [ "$base" != "." ]
			echo "$base" >> sequences.txt
	end
end