#!/usr/bin/env bash

if [[ ! "$(ls /dev/ttyACM0)" && ! "$(ls /dev | grep -i android)" ]]; then
	echo "Make sure to connect the device via USB and that it has MTP and USB debugging enabled."
	exit 1
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Samsung CSC Changer"
echo "Made by: @Pealeap"
echo "GitHub: Filipemendonca1978"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

stty -F /dev/ttyACM0 115200 raw

sendAT() {
	echo -ne "$1"'\r' > /dev/ttyACM0
}

adb shell am start -n com.samsung.android.dialer/.DialtactsActivity
adb shell input text "*#0*#"

echo "Available/compatible CSCs:"
adb shell ls /optics/configs/carriers/single

read -p "Select one CSC: " csc
sendAT AT+SWATD=0
sendAT AT+ACTIVATE=0,0,0
sendAT AT+SWATD=1
sendAT AT+PRECONFG=2,$csc

echo "Done! Rebooting..."
adb reboot
