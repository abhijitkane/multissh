multissh
========

Run commands on multiple ssh targets


**Usage:** 

chmod +x multissh.sh
./multissh.sh [serverFile] [username] [password] [commandFile] [outputFile]

where,
serverFile is a newline-separated list of nodes that you want to ssh into. e.g. prodServers (attached)
commandList is a newline-separated list of commands that you want to run on each node eg. commands (attached)
outputFile – the file that the output should be written to

Note – one line in the commandList file will correspond to one statement in the output file. If you want to see all files in dir1, then see all files in dir2, your commandFile should contain:

cd /dir1; ls
cd /dir2; ls