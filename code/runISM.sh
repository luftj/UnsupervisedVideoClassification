#!/bin/fish

# this script builds codebooks for every sequence in less data/input/frames/sequences.txt
# 
# uses Bastian Leibe and Bernt Schiele,                    
# Interleaved Object Categorization and Segmentation.
# In Proc. British Machine Vision Conference (BMVC'03),
# Norwich, GB, Sept. 9-11, 2003.                    
# and
# Bastian Leibe, Ales Leonardis and Bernt Schiele,                    
# Combined Object Categorization and Segmentation with an Implicit Shape
# Model. submitted to ECCV'04 Workshop on Statistical Learning in Computer
# Vision, Prague, May, 2004.
#
# for usage of ./ISM/clusterer9/clusterer please consider ./ISM/clusterer9/readme.txt

for sequence in (less data/input/frames/sequences.txt)
	echo $sequence
	if test -d data/inter/frames/$sequence
		set sequence (basename $sequence)
		for object in (ls -1 -d data/inter/frames/$sequence/*/)
			set object (basename $object)
			if test -d "files/codebooks/"$sequence"_"$object
				continue
			end
			if test $object -eq 0	# hacky, handling of background is future work
				continue
			end

			echo "Running ISM clustering on sequence" $sequence\_$object
			
			mkdir files/codebooks/$sequence\_$object # output directory
			# do the magic. use cars.params instead of carsall.params for using pixel patches instead of shape context descriptors
			./ISM/clusterer9/clusterer -nw -vv -p files/carsall.params -idl files/$sequence\_$object.idl -o files/codebooks/$sequence\_$object/$sequence\_$object #attention! -p BEFORE -idl! (otherwise figure area only param won't have effect)
			#touch $outdir/stdout.txt
			#touch $outdir/stderr.txt
			# > $outdir/stdout.txt 2> $outdir/stderr.txt # use this for logging, maybe remove -vv flag (it's VERY verbose)
		end
	end
end