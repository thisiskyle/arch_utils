#!/bin/bash


# get the target device from the user
echo "What drive are we installing arch on?"
echo "WARNING: THIS DEVICE WILL BE COMPLETELY ERASED"
read targetDev

# get the fdisk command list you want to run
echo "What fdisk commands are we using (without file extension)?"
read fdiskCmdFilename

fdiskCmdDir="${HOME}/arch_util/data"
fdiskCmdFile="${HOME}/arch_util/data/fdisk/${fdiskCmdFilename}.txt"

# partition the drive with fdisk
grep -v "^#" < ${fdiskCmdFile} | fdisk "${targetDev}"

# TODO/incomplete: make the file system
# TODO/incomplete: set locale stuff
# TODO/incomplete: other things i dont remember right now...

