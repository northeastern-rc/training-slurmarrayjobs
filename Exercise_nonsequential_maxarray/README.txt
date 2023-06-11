In this folder, we have a folder named 'directories'. 'directories'
contains multiple sub-folders which contain a job.sh file.  This
example script simply prints 'Hello World' to the console.

In order to process these files, we can use main.sh script as follows:
./main.sh directories f job.sh output

This will generate some .out and .err files, and output folders
starting with the name 'output' and the corresponding Slurm job and
task array IDs appended. If you 'cat' the contents of .out files, you
should see 'Hello World' in those files. 
