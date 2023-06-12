#!/bin/bash

#SBATCH --partition=reservation  # Use a regular partition such as "express" when not in training & remove --reservation 
#SBATCH --reservation=bootcamp_cpu_2023
#SBATCH --nodes 1
#SBATCH --cpus-per-task=1
#SBATCH -t 1:00:00
#SBATCH --mem=1G
#SBATCH --job-name="Fastqc_arrayjob"
#SBATCH --output=%A-%a.out
#SBATCH --error=%A-%a.err
#SBATCH --array=1-3%3 ## This will submit an array of 3 jobs, all 3 at the same time


# Load the system wide fastqc module & dependency module 
module load oracle_java/jdk1.8.0_181
module load fastqc/0.11.8

#Run fastqc on each sample using the SLURM_ARRAY_TASK_ID environmental variable
fastqc wgEncode${SLURM_ARRAY_TASK_ID}_Sub.fq 
