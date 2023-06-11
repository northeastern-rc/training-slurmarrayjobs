#!/bin/bash

# Usage: 
# ./main.sh path_to_foler keyword_of_scripts_to_run
# Example: ./main.sh test_folder job.sh

WORKDIR=$1

# Check if the keyword to search for desired input files is provided
# by the user or not
KEYWORD=$2
if [ -z "$KEYWORD" ] || [ $# -lt 2 ]
then
    echo "The script requires the keyword, to search for desired entries, as its 2nd command line argument."
    exit
fi

# Save all the entries that match the KEYWORD criteria in job_file_paths.txt
rm -f job_file_paths.txt
find $WORKDIR -type f -name "$KEYWORD" 2> /dev/null > job_file_paths.txt
ENTRIES=$(wc -l job_file_paths.txt | awk '{print $1}')
echo "Number of entries are $ENTRIES"


# Iterate over all the entries in job_file_paths.txt
# ENTRIES is the number of files that need to be processed
# Each iteration of this loop schedules a sbatch with an array size of
# LIMIT
# Thus, each iteration of this loop will process ENTRIES from
# job_file_paths.txt, compare it to MAX_ARRAY_SIZE, and assign the
# leser value to LIMIT. The OFFSET and ENTRIES will be updated based
# on their original values and the value of LIMIT.
OFFSET=0
MAX_ARRAY_SIZE=1000
while [[ $ENTRIES -gt 0 ]]
do
    LIMIT=$(( ENTRIES > MAX_ARRAY_SIZE ? MAX_ARRAY_SIZE - 1 : ENTRIES - 1 ))
    sbatch --array=0-$LIMIT array_script.sh $OFFSET
    OFFSET=$((OFFSET + (LIMIT + 1) ))
    ENTRIES=$(( ENTRIES - (LIMIT + 1) ))
done
