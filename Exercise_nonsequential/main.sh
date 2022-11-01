#!/bin/bash

# Bash script to list the number of sub-folders starting with the
# keyword 'sub' located inside a working directory. It then submits a
# Slurm job as an array job of array size equal to the number of 'sub'
# sub-folders along with a batch script to process those folders.

# Usage:
# ./main.sh

# Change 'WORKDIR' based on desired location
WORKDIR=$PWD/masks

ENTRIES=$(ls $WORKDIR | grep sub | wc -l)

sbatch --array=1-$ENTRIES array_job_nonsequence.sh
