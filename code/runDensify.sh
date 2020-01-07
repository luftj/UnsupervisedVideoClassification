#!/bin/fish

# this script calculates dense motion segmentation for every sequence in data/input/frames/sequences.txt that has sparse segmentation. requires sshpass
# using: Peter Ochs, Jitendra Malik, Thomas Brox 
# Segmentation of moving objects by long term video analysis
# IEEE Transactions on Pattern Analysis and Machine Intelligence, preprint, 2013. 
# for ./dens100gpu usage refer to MotSeg/readme.txt
# ./dens100gpu only runs on NVIDIA GPUs with CUDA, therefore this script connects to titan.cv.tu-berlin.de for calculations.

set remote $argv[6]			# ssh address uri for remote densify
set user $argv[1]			# ssh credentials for login to remote
set password $argv[2] 		# ibd.
set mosegsampling $argv[3]	# for finding the correct folder
set mosegnu $argv[4]		# ibd.

for sequence in (less data/input/frames/sequences.txt)
	if test -d "data/inter/tracking/OchsBroxMalik$mosegsampling\_all_00000$mosegnu.00/$sequence"
		echo $sequence
		if test -d "data/inter/denseSeg/$sequence" 
			echo "already densified"
			continue
		end

		set tracksfile (basename (ls data/inter/tracking/*/$sequence/Tracks*.dat))
		
		sshpass -v -p$password ssh -o StrictHostKeyChecking=no $user@$remote "mkdir data/input/$sequence; mkdir data/input/tracking/$sequence; mkdir data/output/denseSeg/$sequence"

		# copy input files to remote
		sshpass -v -p$password scp -r data/inter/tracking/*/$sequence/sparsesegmentation/*.ppm $user@$remote:data/input/tracking/$sequence
		sshpass -v -p$password scp -r data/input/frames/$sequence/*.ppm $user@$remote:data/input/$sequence
		sshpass -v -p$password scp data/inter/tracking/*/$sequence/$tracksfile $user@$remote:data/input/tracking/$sequence/$tracksfile

		# do the magic
		sshpass -v -p$password ssh -o StrictHostKeyChecking=no $user@$remote "cd moseg/; LD_LIBRARY_PATH=./ ./dens100gpu filestructure.cfg $sequence/image.ppm $sequence/$tracksfile -1 $sequence/; rm ../data/output/denseSeg/$sequence/$tracksfile"
		
		# copy output files to local
		sshpass -v -p$password scp -r $user@$remote:data/output/denseSeg/$sequence/ data/inter/denseSeg/
	end
end
