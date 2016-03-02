#!/bin/bash

# create job files (using create.sh), and submit array jobs

./create.sh qaqa $1 6 qaqaMLnf
./create.sh qjqj $1 6 qjqjMLnf
./create.sh gaga $1 36 gagaMLnf
./create.sh gjgj $1 70 gjgjMLnf
./create.sh haha $1 8 hahaMLnf
./create.sh hjhj $1 6 hjhjMLnf

# submit as array-job
qsub -t 1-6 runfiles/qaqa/$1/submit-array
qsub -t 1-6 runfiles/qjqj/$1/submit-array
qsub -t 1-36 runfiles/gaga/$1/submit-array
qsub -t 1-70 runfiles/gjgj/$1/submit-array
qsub -t 1-8 runfiles/haha/$1/submit-array
qsub -t 1-6 runfiles/hjhj/$1/submit-array

