#!/bin/fish

# this script learns occurence distributions for every codebook
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
# for usage of ./ISM/scmatcher9/scmatcher... Sorry, they didn't provide a readme. Only:
# "A program for object recognition with a single detector.
# This program can also be used to create occurrence files
# for training a new detector (and for saving it for later
# use with mcmatcher3)."
# -co argument implemented by us for CLI batch processing.

for sequence in (ls -1 -d  files/codebooks/*/)
	set sequence (basename $sequence)
	if test -e files/codebooks/$sequence/$sequence-no1pc_occ.flz
		continue
	end
	if test -e files/codebooks/$sequence/$sequence-no1pc.flz
		echo "Creating occurence files for sequence" $sequence
		
		# do the magic
		./ISM/scmatcher9/scmatcher -co files/codebooks/$sequence/$sequence-no1pc.flz files/$sequence.idl files/codebooks/$sequence/$sequence-no1pc_occ.flz
		
		rm files/codebooks/$sequence/cues.txt
		touch files/codebooks/$sequence/cues.txt
		echo $sequence >> files/codebooks/$sequence/cues.txt
	end
end