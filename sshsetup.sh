#!/bin/sh
yes | pkg install openssh
yes | pkg install iproute2
clear
echo ""
echo "Please create ssh Password"
echo "--------------------------"
passwd
./sshcommand.sh