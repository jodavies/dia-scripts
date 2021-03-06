#!/bin/bash

# For runs where diagrams are split over jobs, we need to merge to create one database.
# The run directories contain a minos script which sums only.

# We merge into the database in dia-1.

for a in runfiles/$1/$2/dia-*;
do
#	skip dia-1
	if [ $a == "runfiles/$1/$2/dia-1" ]
	then
		continue
	fi
#	call my merge script
	minosmerge runfiles/$1/$2/dia-1/$1Lnfres.dat $a/$1Lnfres.dat runfiles/$1/$2/dia-1/$1Lnfres.dat
done

cd runfiles/$1/$2/dia-1
minos makesum
