#!/bin/fish

# when frames have been trimmed in ./prepareISMfiles.sh, this makes sure the 
# relative output numbering translates to the absolute frame numbering and thus can be compared

set detector $argv[1]	# detector to use
set sequence $argv[2]	# video to check
set object $argv[3]		# object to check

set files (ls -1 data/inter/frames/$sequence/$object/*.png)

set resfile data/output/training/$detector-$sequence\_$object/results.txt # input file with detection results in relative frame numbering
set newresfile data/output/training/$detector-$sequence\_$object/relresults.txt # output file with absolute frame numbering

rm $newresfile
touch $newresfile

for line in (less $resfile)
	set line (echo $line | string split " ")
	set oldframenum (math $line[1]+1)
	set framenum (echo $files[$oldframenum] | sed -r 's/.*-([0-9]*).png/\1/')
	set framenum (echo $framenum | sed -r 's/^0*//')
	echo $framenum $line[2..-1] >> $newresfile
end
