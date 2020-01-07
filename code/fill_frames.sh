#!/bin/fish

# this script was used to fill in missing frames in the figure masks, because ISM detection has bugs and gives strange results...
# Not necessary since input videos are trimmed anyway.

set i 1
set padi (printf "%04d" $i)
set sequence $argv[2]

for it in (ls -1 $argv[1])
	set num (echo $it | sed 's/virat0500-//')
	set num (echo $num | sed 's/-map.png//')
	if test $padi -eq $num
		#echo "good"
	else
		cp $argv[1]/../../../$sequence-0000-map.png $argv[1]/$sequence-$padi-map.png
		echo $padi
		set i (math $i+1)
	end

	set i (math $i+1)
	set padi (printf "%04d" $i)
end