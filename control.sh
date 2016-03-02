#!/bin/bash

# Script to control calculation of moments of 4 loop structure functions.
#
# The first argument:
# - CREATE: Create per-job files to run on a cluster. Set below the number of diagrams
#           in the database, and how many diagrams each job should run.
# - SUBMIT: Unused, now we use array jobs
#
# Arguments 2-5 set some parameters:
REACTION=$2
MELMOM=$3
NDIASPERJOB=$4
NDIAGRAMS=$5


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
# ensure $NDIASPERJOB ($4) is a positive integer, this is the number of diagrams per job
if ! [[ $NDIASPERJOB =~ ^[0-9]+$ ]]
then
	echo "The fourth argument must be a positive integer! (The number of diagrams per job)"
	exit
fi
# ensure $NDIAGRAMS ($5) is a positive integer, this is the number of diagrams
if ! [[ $NDIAGRAMS =~ ^[0-9]+$ ]]
then
	echo "The fifth argument must be a positive integer! (The number of diagrams)"
	exit
fi




if [ -d "runfiles/$REACTION/$MELMOM" ]
then
	NOW=$(date +"%Y-%m-%d--%H-%M-%S")


	if [ "$1" == "SUBMIT" ]
	then
		echo "Submit mode. DEPRECIATED, USE ARRAY JOB"
		exit
	else
		echo "Error! Directory for moment $MELMOM already exists! Exiting..."
		exit
	fi


fi
	


# Make working dir for this moment
mkdir -p runfiles/$REACTION/$MELMOM



# copy array-job submit script to dir and set vars
cp submit-array runfiles/$REACTION/$MELMOM
sed -i -e "s/SETMEREAC/$REACTION/g" runfiles/$REACTION/$MELMOM/submit-array
sed -i -e "s/SETMEMOM/$MELMOM/g" runfiles/$REACTION/$MELMOM/submit-array


for ((DIAF=1; DIAF <= $NDIAGRAMS; DIAF += $NDIASPERJOB))
do
	TMP=$(($DIAF+$NDIASPERJOB-1))
	DIAL=$(($TMP>$NDIAGRAMS?$NDIAGRAMS:$TMP))


#	if first argument is CREATE, create runfiles and fill in variables
	if [ "$1" == "CREATE" ]
	then
		cp -r template runfiles/$REACTION/$MELMOM/dia-$DIAF
		sed -i -e "s/SETMEREAC/$REACTION/g" runfiles/$REACTION/$MELMOM/dia-$DIAF/calcdia.frm
		sed -i -e "s/SETMEMOM/$MELMOM/g" runfiles/$REACTION/$MELMOM/dia-$DIAF/calcdia.frm
#
		sed -i -e "s/SETMEREAC/$REACTION/g" runfiles/$REACTION/$MELMOM/dia-$DIAF/makeres
		sed -i -e "s/SETMEMOM/$MELMOM/g" runfiles/$REACTION/$MELMOM/dia-$DIAF/makeres
		sed -i -e "s/SETMEDIAF/$DIAF/g" runfiles/$REACTION/$MELMOM/dia-$DIAF/makeres
		sed -i -e "s/SETMEDIAL/$DIAL/g" runfiles/$REACTION/$MELMOM/dia-$DIAF/makeres
#
		sed -i -e "s/SETMEREAC/$REACTION/g" runfiles/$REACTION/$MELMOM/dia-$DIAF/makesum
	fi


#	if first argument is SUBMIT, submit jobs to queue (control shouldn't reach here...)
	if [ "$1" == "SUBMIT" ]
	then
		echo submitting $REACTION-$MELMOM-dia-$DIAF-$DIAL
		qsub runfiles/$REACTION/$MELMOM/dia-$DIAF/submit
	fi


done

