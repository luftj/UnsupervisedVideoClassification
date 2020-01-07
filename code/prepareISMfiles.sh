#!/bin/fish

# this script prepares files for codebooks building. Takes figure masks and input video frames, trims any frames without figure area

for sequence in (ls -1 ExSeg/output/)
	if test -d data/inter/frames/$sequence
		continue
	end

	echo "Preparing files for ISM on" $sequence
	mkdir data/inter/frames/$sequence
	for object in (ls -1 ExSeg/output/$sequence/)
		# todo: simply skip object 0? naive bg-removal
		echo $object
		mkdir data/inter/frames/$sequence/$object

		for file in data/input/frames/$sequence/*.???
			convert $file data/inter/frames/$sequence/(basename (basename (basename (basename $file .ppm) .pgm) .jpg)).png # ISM takes png
		end

		mkdir data/inter/frames/$sequence/$object/maps
		cp ExSeg/output/$sequence/$object/*.png data/inter/frames/$sequence/$object/maps # ISM implementations has peculiar hard-coded paths...

		rm files/$sequence\_$object.idl
		touch files/$sequence\_$object.idl
		set objpath data/inter/frames/$sequence/$object
		
		for file in $objpath/maps/*.png
			set file (echo $file | sed 's/-map//' | cat)
			set file (echo $file | sed "s/\/$object\/maps//" | cat)
			cp $file data/inter/frames/$sequence/$object/(basename $file)
			echo \"../$objpath/(basename $file)\"\; >> files/$sequence\_$object.idl
		end
		echo (less files/$sequence\_$object.idl | sed 's/.png";//' | sed -r 's/.*-//') # .idl file for batch processing
	end
end