#!/bin/fish

# counts number of test detections of each detector for evaluation

for detector in (less files/codebooks/detectors.txt)
	set sum 0
	for file in (ls -1 data/output/detection/"$detector"*/results.txt)
		set sum (math "$sum"+(string split " " (wc -l $file))[1])
	end
	echo $detector $sum
end