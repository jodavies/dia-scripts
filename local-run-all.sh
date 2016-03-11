#!/bin/bash

# Run a whole reaction's diagrams with minos, outside of a queue system.
# This script is copied and setup by 0-go.sh, in case we want to run like this.
# The following environment variables should be exported in env:
# -   FORMTMPROOT: base dir for scratch files. Folders created in here
# -   FORMPATH: directory containing procedures used by calcdia.frm etc

###############################################################################


export FORMPROCESSORS=8
export MINOSPROCESSORS=3

################################################################################

trap "echo error! Job terminating early: `date`" SIGINT SIGTERM SIGKILL

SCRATCHDIR=$FORMTMPROOT/SETMEREAC/SETMEMOM/dia-1

# set up scratch space
mkdir -p $SCRATCHDIR
if [ ! -d $SCRATCHDIR ]
then
	echo Error, could not create scratch directory $SCRATCHDIR
	exit
fi
export FORMTMP=$SCRATCHDIR

echo STARTTIME `date`
STARTSTAMP=`date +"%s"`

#################################################################################

# cd into working dir. submit scripts queued from above
cd runfiles/SETMEREAC/SETMEMOM/dia-1

while true; do du -s $FORMTMP >> diskuse.log; sleep 20; done &

# Start diagram calculation. Correct diagram range for minos
# has been set by script which creates the runfiles, ie, it fills
# in SETMEMOM, $TASKNUMBER, $TASKNUMBER
minos makeres-runall

# remove scratch space - KEEP FILES ON CRASH FOR DEBUGGING PURPOSES.
#                        A CLEAN EXIT WILL LEAVE JUST AN EMPTY FOLDER.
#rm -r $SCRATCHDIR

kill $!

# print run times
echo ENDTIME `date`
ENDSTAMP=`date +"%s"`
echo RUNTIME: $(($ENDSTAMP-$STARTSTAMP))


