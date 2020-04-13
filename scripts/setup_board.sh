#!/bin/bash
set -x
if [[ ( $# -ne 2 ) || ( $1 != "rx" &&  $1 != "tx" ) ]]; then
	echo "correct usager is $0 rx or $0 tx"
	exit 1
fi

BOARD=$1
AR_FILE=$2

wget https://github.com/manochavikas/stm32mp1_st60_demo/archive/$AR_FILE
unzip -o $AR_FILE

#Remove the .zip extension & pick last 6 chars of zipped file name as
#seems like github provides maximum 7 last characters of tag &
#master.zip contains 6 characters. So let's use last 6 character of
#unzipped file with wild character * to change directory.

ar_file_tail=${AR_FILE:0:-4}
ar_file_tail=${ar_file_tail: -6}
echo "last 6 character without extension are = $ar_file_tail"
cd stm32mp1_st60_demo-*$ar_file_tail

if [ $BOARD == "rx" ]; then
	echo "setting up rx board"
	cp config_files/20-wired-rx.network /etc/systemd/network/
elif [ $BOARD == "tx" ]; then
	echo "setting up tx board"
	cp config_files/20-wired-tx.network /etc/systemd/network/
else
	echo "$BOARD is not a correct argument entry"
	exit 2
fi

systemctl enable systemd-networkd
systemctl restart systemd-networkd

if [ $BOARD == "rx" ]; then
	chmod +x scripts/rx_script.sh
elif [ $BOARD == "tx" ]; then
	chmod +x scripts/tx_script.sh
else
        echo "$BOARD is not a correct argument entry"
        exit 2
fi
