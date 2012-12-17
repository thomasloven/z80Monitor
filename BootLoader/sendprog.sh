#!/bin/bash

tail -c +0 hello.bin | head -c 64 > /dev/cu.usbmodemfa131
sleep 3
tail -c +65 hello.bin | head -c 64 > /dev/cu.usbmodemfa131
sleep 3
tail -c +129 hello.bin | head -c 64 > /dev/cu.usbmodemfa131
sleep 3
tail -c +193 hello.bin | head -c 64 > /dev/cu.usbmodemfa131
sleep 3
tail -c +257 hello.bin | head -c 64 > /dev/cu.usbmodemfa131
