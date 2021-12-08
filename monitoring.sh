#!/bin/bash

MESSAGE_FINAL=""
SOCKET=$(lscpu | head -9 | tail -1 | awk '{printf "%s", $2}')
CORE=$(lscpu | head -8 | tail -1 | awk '{printf "%s", $4}')
THREAD=$(lscpu | head -7 | tail -1 | awk '{printf "%s", $4}')
CPU=$((SOCKET * CORE))
VCPU=$((SOCKET * CORE * THREAD))
MEMORY_TOTAL=$(free -m | tail -2 | head -1 | awk '{printf "%s", $2}')
MEMORY_USED=$(free -m | tail -2 | head -1 | awk '{printf "%s", $3}')
MEMORY_PERC=$(bc <<< "scale=2;${MEMORY_USED}*100/${MEMORY_TOTAL}")
DISK_USAGE=$(df -h | grep "vg-root" | awk '{printf "%s", $3}')
DISK_TOTAL=$(df -h | grep "vg-root" | awk '{printf "%s", $4}')
DISK_USED=$(df -h | grep "vg-root" | awk '{printf "%s", $3}')
DISK_PERC=$(df -h | grep "vg-root" | awk '{printf "%s", $5}')
CPU_LOAD=$(mpstat 1 1 | tail -1 | awk '{printf "%s", 100-$12}')
LAST_BOOT=$(who -b | awk '{printf "%s %s", $3, $4}')
test $(lvscan | head -1 | awk '{printf "%s", $1}') = "ACTIVE" && LVM_USE="yes" || LVM_USE="no"
TCP_CONEX=$(ss | grep "tcp" | wc -l)
USER_LOG=$(who | awk '{printf "%s\n", $1}' | uniq | wc -w)
IP4=$(ip -4 -o address show | grep enp0s3 | awk '{printf "%s", $4}' | cut -d "/" -f 1)
MAC_ADDRESS=$(ip a | grep link/ether | awk '{printf "%s", $2}')
SUDO_OP=$(echo "ibase=16; $(cat /var/log/sudo/seq)" | bc)

eval MESSAGE[0]=\$\'#Architecture: $(uname -a)\\n\'
eval MESSAGE[1]=\$\'#CPU physical : ${CPU}\\n\'
eval MESSAGE[2]=\$\'#vCPU : ${VCPU}\\n\'
eval MESSAGE[3]=\$\'#Memory Usage : ${MEMORY_USED}/${MEMORY_TOTAL}MB \(${MEMORY_PERC}%\)\\n\'
eval MESSAGE[4]=\$\'#Disk Usage : ${DISK_USED}/${DISK_TOTAL} \(${DISK_PERC}\)\\n\'
eval MESSAGE[5]=\$\'#CPU Load : ${CPU_LOAD}%\\\n\'
eval MESSAGE[6]=\$\'#Last Boot : ${LAST_BOOT}\\\n\'
eval MESSAGE[7]=\$\'#LVM use : ${LVM_USE}\\\n\'
eval MESSAGE[8]=\$\'#Connexions TCP : ${TCP_CONEX} ESTABLISHED\\\n\'
eval MESSAGE[9]=\$\'#User log : ${USER_LOG}\\\n\'
eval MESSAGE[10]=\$\'#Network : IP ${IP4} \(${MAC_ADDRESS}\)\\\n\'
eval MESSAGE[11]=\$\'#Sudo : ${SUDO_OP} cmd\\\n\'


for i in $(seq 0 $((${#MESSAGE[@]} - 1)))
do
        MESSAGE_FINAL="${MESSAGE_FINAL}${MESSAGE[$i]}"
done

echo "${MESSAGE_FINAL::${#MESSAGE_FINAL}-1}"
