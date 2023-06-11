In this folder, we have a folder named 'directories'. 'directories' contains multiple sub-folders which contain a job.sh file.
This example script simply prints 'Hello World' to the console.

In order to process these files, we can use main.sh script as follows:
./main.sh directories job.sh

This will generate some .out and .err files, and if you 'cat' the contents of .out files, you should see 'Hello World' in those files.
