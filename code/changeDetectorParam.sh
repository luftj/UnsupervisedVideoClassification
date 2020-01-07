#!/bin/fish

# Changes parameters in all current detectors
# ./ISM/mcmatcher3/readme.txt has some notes.
# See files/cars.params for identifiers

set param $argv[1] # substring of parameter identifier
set value $argv[2] # new value

echo "Changing parameter" $param "to" $value
for detector in (less files/codebooks/detectors.txt)
	#echo "Changing parameter" $param "in detector" $detector "to" $value

	sed -i "s/$param: [0-9\.]*/$param: $value/" files/codebooks/$detector/$detector.det
end