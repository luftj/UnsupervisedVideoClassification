#!/bin/fish

# this compiles our own c++ helper tools.

echo "Compiling ExSeg..."
pushd ExSeg
make
popd
echo "Done."
echo "Compiling CatMe..."
pushd CatMe
make
popd
echo "Done."