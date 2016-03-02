#!/bin/bash

# runtime and disk usage recorded by minos, per diagram. Takes moment as argument

rm stats/$1

for reac in qaqa qjqj gaga gjgj haha hjhj
do
	minosshow runfiles/$reac/$1/dia-1/${reac}Lnfres.dat | grep EXT > stats/$reac$1
	sed -i -e "s/ EXTIME=//g" stats/$reac$1
	cat stats/$reac$1 >> stats/$1
	grep RUNTIME runfiles/$reac/$1/*.o*[.-]* > stats/job-$reac-$1
done
