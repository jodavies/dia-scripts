#!/bin/bash

# Fetch results from total.log files. Takes moment as argument

mkdir -p results/$1

for reac in qaqa qjqj gaga gjgj haha hjhj
do
	cp runfiles/$reac/$1/dia-1/total.log results/$1/$reac-$1.h
	fformat results/$1/$reac-$1.h
	sed -i -e "s/Fsum/F$reac$1/g" results/$1/$reac-$1.h
done
