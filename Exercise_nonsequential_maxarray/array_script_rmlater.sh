#!/bin/bash

# Usage: ./array_script.sh OFFSET
# This script will run and operate on the OFFSET line number in job_file_paths.txt

# These are placeholder SBATCH parameters just for testing. 

#SBATCH -p short
#SBATCH --mem=1M
#SBATCH --job-name=cp2
#SBATCH --cpus-per-task=1
#SBATCH --time=00:02:00
#SBATCH -o %A_%a.out
#SBATCH -e %A_%a.err

# Get the number of folders to be processed
JOBLIMIT=$(wc -l job_file_paths.txt | awk '{print $1}')

OFFSET=$1
if [ -z "$OFFSET" ]
then
  OFFSET=0
fi


# If no more folders to process, then exit
FOLDER_NUMBER=$((OFFSET + SLURM_ARRAY_TASK_ID))
if [ $((FOLDER_NUMBER)) -ge ${JOBLIMIT} ]
then
  exit
fi

# Main Logic (Currently commented out actual user's code for testing purposes)

#export OMP_NUM_THREADS=8
#module load openmpi/3.1.1
#module load cp2k/cp2k-6.1.0
#inputFile=$dir/job-1.restart
#cp2k.psmp $inputFile

file_path=$(awk "NR==$((FOLDER_NUMBER+1))" job_file_paths.txt)
dir=$(dirname '$file_path')
pushd $dir > /dev/null
$file_path

popd > /dev/null