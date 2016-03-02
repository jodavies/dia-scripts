#!/bin/bash

# create job files (using control.sh), and submit array jobs

./control.sh CREATE qaqa $1 1 6
./control.sh CREATE qjqj $1 1 6
./control.sh CREATE gaga $1 1 36
./control.sh CREATE gjgj $1 1 70
./control.sh CREATE haha $1 1 8
./control.sh CREATE hjhj $1 1 6

# submit as array-job
qsub -t 1-6 runfiles/qaqa/$1/submit-array
qsub -t 1-6 runfiles/qjqj/$1/submit-array
qsub -t 1-36 runfiles/gaga/$1/submit-array
qsub -t 1-70 runfiles/gjgj/$1/submit-array
qsub -t 1-8 runfiles/haha/$1/submit-array
qsub -t 1-6 runfiles/hjhj/$1/submit-array

