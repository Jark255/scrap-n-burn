# scrap-n-burn
Simple shell scripts to help with disk backup

## Requirements
 * xzcat (needed for burn-my-disk.sh)
 * pv (optional; for better status output)

## scrap-my-disk.sh
Script to make an xz

```
Usage:
./scrap-my-disk BLOCK_DEVICE OUTPUT_FILE.xz [ [THREAD_AMOUNT] BLOCK_SIZE]
BLOCK_DEVICE           -- path to your disk (e.g. /dev/sda)
OUTPUT_FILE.xz         -- path to compressed file (do not forget .xz, this script doesn't make it)
THREAD_AMOUNT (def: 8) -- amount of threads to use while compressing (beware! you will need that exact amount to decompress either ;)
BLOCK_SIZE (def: 4096) -- size of blocks to process at one time in bytes (bs in dd)
```

## burn-my-disk.sh
Script to write contents of backup to disk

```
Usage:
$0 INPUT_FILE.xz BLOCK_DEVICE [ [THREAD_AMOUNT] BLOCK_SIZE]
INPUT_FILE.xz          -- path to compressed file (do not forget .xz, this script doesn't make it)
BLOCK_DEVICE           -- path to your disk (e.g. /dev/sda)
THREAD_AMOUNT (def: 8) -- amount of threads to use while compressing (beware! you will need that exact amount used while compressing file ;)
BLOCK_SIZE (def: 4096) -- size of blocks to process at one time in bytes (bs in dd)
```