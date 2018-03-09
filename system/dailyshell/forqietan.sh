#!/bin/bash
set -e

for I in 1 2 3 4 5
do
    echo $I
	for IS in a b c d e
	do
	echo $I$IS
    break
	done
done

