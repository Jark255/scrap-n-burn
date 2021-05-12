#!/bin/sh

#
# burn-my-disk.sh -- Script which grabs everything it can from given xz compressed image and writes it to specified device
# Author: Jark255
# Licensed under GPLv3+
#

function printUsage {
	echo "Usage: "
	echo "$0 INPUT_FILE.xz BLOCK_DEVICE [ [THREAD_AMOUNT] BLOCK_SIZE]"
	echo "INPUT_FILE.xz          -- path to compressed file (do not forget .xz, this script doesn't make it)"
	echo "BLOCK_DEVICE           -- path to your disk (e.g. /dev/sda)"
	echo "THREAD_AMOUNT (def: 8) -- amount of threads to use while compressing (beware! you will need that exact amount used while compressing file ;)"
	echo "BLOCK_SIZE (def: 4096) -- size of blocks to process at one time in bytes (bs in dd)"
}

if [[ -n "${1+set}" ]]; then
	if [[ -e "$1" ]]; then
		file=$1
	else
		echo "$1 does not exist"
		exit 2
	fi
else
	printUsage
	exit 1
fi

if [[ -n "${2+set}" ]]; then
	if [[ -e "$2" ]]; then
		disk=$2
	else
		echo "$2 does not exist"
		exit 2
	fi
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

size_of_file=$(wc -c <"$file")
size_of_disk=$(cat /sys/class/block/$(basename $disk)/size)
(( size_of_disk*=512 ))

if ! command -v xzcat &> /dev/null; then
	echo "You don't have xzcat installed but it is needed for script to work. Aborting..."
	exit 3
fi

if [[ $size_of_file -gt $size_of_disk ]]; then
	echo "It certianly won't fit, chief!"
	exit 4
fi

if ! command -v pv &> /dev/null; then
	echo "pv not found. Proceeding without it..."
	xzcat -d -T $thread_amount $file | sudo dd of=$disk bs=$block_size status=progress
else
	xzcat -d -T $thread_amount $file | pv -ptera -s $size_of_file | sudo dd of=$disk bs=$block_size
fi
