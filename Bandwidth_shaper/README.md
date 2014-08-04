Help
-----
1. Initialize on interface INAME:
  * `sudo ./netem.sh INAME init`

2. specify configuration file and time period in seconds of switch from one network status to the next one:
  * `sudo ./netem.sh INAME cpnfig.txt 2`

Show netem status
-----------------
`./netem.sh INAME ls`

Deinitialize
------------
`sudo ./netem.sh INAME deinit`

Abot the configuration file
----------------------------
- first line specifies the number of nodes
- second line specifies the number of archs

the next row depends on the previous two rows
- one line per node specifing the min treshold and the max treshold of the bitrate for that node
- one line per arch specifing the min treshold and the max treshold of the probabiliry of moving to another node
- the first and the last node has ALWAYS 2 archs all the other nodes have ALWAYS 3 archs

for more info see the configuration file sample

