#!/bin/bash

# This script runs the array job spawned using the main.sh script on a
# single node on express partition to process folders starting with
# name sub-blast located inside a work directory.

#SBATCH -J slurm_python
#SBATCH --partition=reservation                                                                                                                                                                                    
#SBATCH --reservation=fall_training_cpu_2022
#SBATCH -o %A_%a.o 
#SBATCH -e %A_%a.e 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:20:00
#SBATCH --mem=4G 

# Use a regular partition, such as express, when not in a training                                                                                                                                                                  
# session                                                                                                                                                                                                                   
##SBATCH --partition=express

module load anaconda3/2022.01

# Change 'BASEDIR' and 'WORKDIR' based on desired locations
BASEDIR=$PWD
WORKDIR=$PWD/masks

ls $WORKDIR | grep sub > filelist.txt

cd $BASEDIR
echo "In $BASEDIR"

dirname=$(awk "NR==${SLURM_ARRAY_TASK_ID}" filelist.txt)

echo "Job array ID: $SLURM_ARRAY_JOB_ID , sub-job $SLURM_ARRAY_TASK_ID is running!"
echo "Sub-job $SLURM_ARRAY_TASK_ID is processing $dirname"

# Do science here

echo "Done processing $dirname"
