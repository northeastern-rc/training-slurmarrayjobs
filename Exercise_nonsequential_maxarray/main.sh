#!/bin/bash

# Bash script to list the number of entries with a given keyword to be
# processed that are located inside a working directory. The script
# accepts this keyword as a command line argument. It then submits a
# Slurm job as an array job of array size equal to the number of
# entries to be processed with a batch script.

# Usage:
# ./main.sh input-folder-name type keyword output-folder-name
# For example: ./main.sh FilesfromPARTGUI f nb* nboutput

# Change 'WORKDIR' based on desired location
WORKDIR=$PWD/$1

echo "Workdir is $WORKDIR"

# Check if the type for entries, file (f) or directory (d) is provided
TYPE=$2
if [ -z "TYPE" ] || [ $# -lt 4 ]
then
    echo "The script needs the type for entries, files (f) or directory (d), to be specified."
    exit
fi

echo "type of entry is $TYPE"

# Check if the keyword to search for desired input files is provided
# by the user or not
KEYWORD=$3
if [ -z "$KEYWORD" ] || [ $# -lt 4 ]
then
    echo "The script, main.sh, requires the keyword, to search for desired entries, as its 3rd command line argument."
    exit
fi

echo "keyword is $KEYWORD"

# Count number of entries inside $WORKDIR with keyword in their
# names
ENTRIES=$(find $WORKDIR -type $TYPE -name "*$KEYWORD*" | wc -l)

echo "Number of entries are $ENTRIES"

# if $ENTRIES > MaxArraySize=1001 then do chunking
# Get the quotient of $ENTRIES/MaxArraySize (1000) and round it up
# Start a loop with the rounded up number as the upper limit 
# Call sbatch with --array=1-i in each iteration

sbatch --array=1-$ENTRIES array_job_massexpt.sh $1 $2 $3 $4 
