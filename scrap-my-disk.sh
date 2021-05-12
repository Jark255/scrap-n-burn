#!/bin/sh

#
# scrap-my-disk.sh -- Script which grabs everything it can from given block device and compress it to .xz file
# Author: Jark255
# Licensed under GPLv3+
#

function printUsage {
	echo "Usage: "
	echo "$0 BLOCK_DEVICE OUTPUT_FILE.xz [ [THREAD_AMOUNT] BLOCK_SIZE]"
	echo "BLOCK_DEVICE           -- path to your disk (e.g. /dev/sda)"
	echo "OUTPUT_FILE.xz         -- path to compressed file (do not forget .xz, this script doesn't make it)"
	echo "THREAD_AMOUNT (def: 8) -- amount of threads to use while compressing (beware! you will need that exact amount to decompress either ;)"
	echo "BLOCK_SIZE (def: 4096) -- size of blocks to process at one time in bytes (bs in dd)"
}

if [[ -n "${1+set}" ]]; then
	if [[ -e "$1" ]]; then
		disk=$1
	else
		echo "$1 does not exist"
		exit 2
	fi
else
	printUsage
	exit 1
fi

if [[ -n "${2+set}" ]]; then
	file=$2
else
	printUsage
	exit 1
fi

if [[ -n "${3+set}" ]]; then
	thread_amount=$3
else
	thread_amount=8
fi

if [[ -n "${4+set}" ]]; then
	block_size=$4
else
	block_size=4096
fi

if ! command -v pv &> /dev/null; then
	echo "pv not found. Proceeding without it..."
	sudo dd if=$disk bs=$block_size status=progress | xz -z -T $thread_amount > $file -
else
	size=$(cat /sys/class/block/$(basename $disk)/size)
	(( size*=512 ))

	sudo dd if=$disk bs=$block_size | pv -ptera -s $size | xz -z -T $thread_amount > $file -
fi
