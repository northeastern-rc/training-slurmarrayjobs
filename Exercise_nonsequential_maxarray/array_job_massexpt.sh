#!/bin/bash

# This script runs the array job spawned using the main.sh script on a
# single node on express partition to process entries with a given
# keyword in their name and are located inside a work directory. The
# keyword is provided as a command line argument in main.sh.

#SBATCH -J mass_expt_test
#SBATCH --partition=express
#SBATCH -o %A_%a.o 
#SBATCH -e %A_%a.e 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:20:00
#SBATCH --mem=4G 


# Change 'BASEDIR' and 'WORKDIR' based on desired locations
BASEDIR=$PWD
WORKDIR=$PWD/$1
OUTDIR=$PWD/$4

# Check if the type for entries, file (f) or directory (d) is provided                                                               
TYPE=$2 
if [ -z "TYPE" ] || [ $# -lt 4 ] 
then 
    echo "The script needs the type for entries, files (f) or directory (d), to be specified."
    exit
fi

echo "type if $TYPE" 

# Check if the keyword to search for desired input files is provided                                                                
# by the user or not                                                                                                                    
KEYWORD=$3
if [ -z "$KEYWORD" ] || [ $# -lt 4 ]
then
    echo "The script, main.sh, requires the keyword, to search for desired entries, as its 3rd command line argument."
    exit
fi

echo "keyword is $KEYWORD"

# Find entries inside $WORKDIR with given keyword in their names and
# redirect the output to filelist.txt
find $WORKDIR -type $TYPE -name "*$KEYWORD*" > filelist.txt

cd $BASEDIR
echo "In $BASEDIR"

entryname=$(awk "NR==${SLURM_ARRAY_TASK_ID}" filelist.txt)

echo "Job array ID: $SLURM_ARRAY_JOB_ID , sub-job $SLURM_ARRAY_TASK_ID is running!"
echo "Sub-job $SLURM_ARRAY_TASK_ID is processing $entryname"

# Do science here
source /shared/centos7/delft3d/env_Delft3D-65936.sh
module load intel/compilers-2021.2.0
module load mpich/3.4.2-intel2021
module load delft3d/65936-intel2021-mpich3.4.2

DIRNAME=$OUTDIR-${SLURM_ARRAY_JOB_ID}-${SLURM_ARRAY_TASK_ID}
mkdir $DIRNAME

cd $DIRNAME
#echo "$entryname" > $DIRNAME/output.log
delpar $entryname >> $DIRNAME/output.log

cd ..

echo "Done processing $entryname"
