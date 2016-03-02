#!/bin/bash

# check a moment for errors, to be called before merging the minos
# databases.

# check all calcdia.log files exist, and that they are complete, i.e.,
# tform has printed final timings. This line contains "sec out of".

for reac in qaqa qjqj gaga gjgj haha hjhj
do
        for a in runfiles/$reac/$1/dia-*
        do
                if ! [ -s $a/calcdia.log ]
                then
                        echo Error! $a/calcdia.log does not exist!
                        echo ""
                else
                        if [ "$(grep -c "sec out of" $a/calcdia.log)" -eq 0 ]
                        then
                                echo Error! $a/calcdia.log exists but is incomplete!
                                grep -i error $a/calcdia.log
                                grep -i terminating $a/calcdia.log
                                echo ""
                        fi
                fi
        done
done
