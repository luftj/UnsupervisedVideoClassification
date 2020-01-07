#!/bin/fish

# if you have .avi files with your input videos this will convert them to single frames and put them where they belong to be processed
# Don't put dashes/hyphens (-) in filenames! Underscores (_) are okay

pushd data/input
mkdir frames
touch frames/sequences.txt
for file in **.avi
	set base (basename $file .avi)
	mkdir frames/$base
	ffmpeg -i $file frames/$base/$base-%03d.ppm
	#pushd frames/$base
	touch $base.bmf
	pushd frames/$base
	echo (ls -1 | wc -l)" 1" >> ../../$base.bmf
	ls -1 >> ../../$base.bmf
	popd
	mv $base.bmf frames/$base
	echo $base >> frames/sequences.txt
end
popd

