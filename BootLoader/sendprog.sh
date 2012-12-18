#!/bin/bash

bytesize=`wc -c $1 | awk '{print $1}'`
currentByte=1
device=/dev/cu.usbmodemfa131

echo $bytesize bytes to send

while [[ $currentByte -le $bytesize ]]; do

echo Sending $currentByte to $(( currentByte + 63 ))

	if [[ $currentByte -eq 1 ]]; then

		tail -c +0 $1 | head -c 64 > $device

	else

		tail -c +$currentByte $1 | head -c 64 > $device

	fi

	sleep 3
	currentByte=$(( currentByte + 64 ))

done
