#!/bin/sh

# Flags for building
export CC=clang
export CXX=clang++
export AR=llvm-ar
export CFLAGS="-g -fsanitize=address"
export CXXFLAGS="-g -fsanitize=address"
export LDFLAGS="-fsanitize=address"

# ASAN needs to know where llvm-symbolizer is
for symbolizer in llvm-symbolizer{,-3.{4,5,6}};
do
	> /dev/null 2>&1 which $symbolizer && export ASAN_SYMBOLIZER_PATH=$(which $symbolizer)
done