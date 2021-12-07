#!/bin/bash

MESSAGE_FINAL=""

eval MESSAGE[0]=\$\'#Architecture : $(uname -s)\\n\'
eval MESSAGE[1]=\$\'#CPU physical :\\n\'
eval MESSAGE[2]=\$\'#vCPU :\\n\'
eval MESSAGE[3]=\$\'#Memory Usage :\\n\'

for i in $(seq 0 $((${#MESSAGE[@]} - 1)))
do
	MESSAGE_FINAL="${MESSAGE_FINAL}${MESSAGE[$i]}"
done

echo "${MESSAGE_FINAL::-1}"

#echo "${MESSAGE[@]}"
#echo "${MESSAGE[*]}"
