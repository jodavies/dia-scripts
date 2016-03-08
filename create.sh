#!/bin/bash

# Script to create job files for diagram calculations. We create one job per diagram.
# Arguments 2-5 set some parameters:
REACTION=$1
MELMOM=$2
NDIAGRAMS=$3
DBNAME=$4




# ensure $REACTION ($2) is valid
if ! [[ $REACTION =~ ^(qaqa|qjqj|gaga|gjgj|haha|hjhj)$ ]]
then
	echo "Invalid REACTION: $REACTION."
	exit
fi
# ensure $MELMOM ($3) is a positive integer, this is the Mellin moment we are working on
if ! [[ $MELMOM =~ ^[0-9]+$ ]]
then
	echo "The third argument must be a positive integer! (The Mellin moment to be computed)"
	exit
fi
# ensure $NDIAGRAMS ($4) is a positive integer, this is the number of diagrams
if ! [[ $NDIAGRAMS =~ ^[0-9]+$ ]]
then
	echo "The fifth argument must be a positive integer! (The number of diagrams)"
	exit
fi




# check necessary environment variables are defined (required by job script)
[ -z "$FORMTMPROOT" ] && echo "Env var FORMTMPROOT must be set!" && exit;
[ -z "$FORMPATH" ] && echo "Env var FORMPATH must be set and include routines!" && exit;




if [ -d "runfiles/$REACTION/$MELMOM" ]
then
	echo "Error! Directory for moment $MELMOM already exists! Exiting..."
	exit
fi




# Make working dir for this moment
mkdir -p runfiles/$REACTION/$MELMOM




# copy array-job submit script to dir and set vars
cp submit-array runfiles/$REACTION/$MELMOM
sed -i -e "s/SETMEREAC/$REACTION/g" runfiles/$REACTION/$MELMOM/submit-array
sed -i -e "s/SETMEMOM/$MELMOM/g" runfiles/$REACTION/$MELMOM/submit-array
# make a script to run the whole job on a single machine, with no queue submission
cp local-run-all.sh runfiles/$REACTION/$MELMOM
sed -i -e "s/SETMEREAC/$REACTION/g" runfiles/$REACTION/$MELMOM/local-run-all.sh
sed -i -e "s/SETMEMOM/$MELMOM/g" runfiles/$REACTION/$MELMOM/local-run-all.sh
chmod +x runfiles/$REACTION/$MELMOM/local-run-all.sh




for ((DIA=1; DIA <= $NDIAGRAMS; DIA += 1))
do
	cp -r template runfiles/$REACTION/$MELMOM/dia-$DIA
	cp db/${DBNAME}dia.dat runfiles/$REACTION/$MELMOM/dia-$DIA/db
	sed -i -e "s/SETMEREAC/$REACTION/g" runfiles/$REACTION/$MELMOM/dia-$DIA/calcdia.frm
	sed -i -e "s/SETMEMOM/$MELMOM/g" runfiles/$REACTION/$MELMOM/dia-$DIA/calcdia.frm
#
	sed -i -e "s/SETMEDIA/$DIA/g" runfiles/$REACTION/$MELMOM/dia-$DIA/makeres
	sed -i -e "s/SETMEDBNAME/$DBNAME/g" runfiles/$REACTION/$MELMOM/dia-$DIA/makeres
	sed -i -e "s/SETMEDIA/$DIA/g" runfiles/$REACTION/$MELMOM/dia-$DIA/makeres-runall
	sed -i -e "s/SETMEFINALDIA/$NDIAGRAMS/g" runfiles/$REACTION/$MELMOM/dia-$DIA/makeres-runall
	sed -i -e "s/SETMEDBNAME/$DBNAME/g" runfiles/$REACTION/$MELMOM/dia-$DIA/makeres-runall
#
	sed -i -e "s/SETMEDBNAME/$DBNAME/g" runfiles/$REACTION/$MELMOM/dia-$DIA/makesum
done

