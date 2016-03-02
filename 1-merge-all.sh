#!/bin/bash

# merge all reactions

echo Merging qaqa$1
./merge.sh qaqa $1
echo
echo Merging qjqj$1
./merge.sh qjqj $1
echo
echo Merging gaga$1
./merge.sh gaga $1
echo
echo Merging gjgj$1
./merge.sh gjgj $1
echo
echo Merging haha$1
./merge.sh haha $1
echo
echo Merging hjhj$1
./merge.sh hjhj $1
