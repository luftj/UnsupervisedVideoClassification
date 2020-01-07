#!/bin/fish

# this script extracts 1 bit figure masks (figure area in white) for every tracked object from the dense segmentation in data/inter/denseSeg/
# takes .ppm or .pgm files in, outputs .png into ExSeg/output/
# requires opencv

for sequence in (ls -1 data/inter/denseSeg/)
	if test -d ExSeg/output/$sequence
		continue
	end
	
	echo "Extracting segmentation of sequence" $sequence
	mkdir ExSeg/input/$sequence/
	for file in data/inter/denseSeg/$sequence/*_dense.p?m
		convert $file ExSeg/input/$sequence/(basename (basename (basename $file .ppm) .pgm) _dense).png
	end

	pushd ExSeg
	./ExSeg  input/ $sequence .png
	popd
end