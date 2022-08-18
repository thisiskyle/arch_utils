#!/bin/bash

echo "Setting time protocol sync"
timedatectl set-ntp true

# get the target device from the user
echo "\nWARNING: THIS DEVICE WILL BE COMPLETELY ERASED"
echo -n "What drive are we installing arch on: "
read targetDev

# get the fdisk command list you want to run
echo -n "\nWhat fdisk command file are we using (without file extension): "
read fdiskCmdFilename

# set up some paths
fdiskCmdDir="${HOME}/arch_util/data"
fdiskCmdFile="${HOME}/arch_util/data/fdisk/${fdiskCmdFilename}.txt"

# couldnt find fdisk command file
if [[ ! -f "${fdiskCmdFile}" ]]; then
    echo "${fdiskCmdFile} not found"
    exit 1
fi

echo -n "Assuming this is a simple EFI install...\nWhat partition will be EFI: "
read efiPartitionNum

echo "What partition will be root: "
read rootPartitionNum

efiPart="${targetDev}${efiPartitionNum}"
rootPart="${targetDev}${rootPartitionNum}"

# TODO/incomplete: check with user that partitions are correct?

echo "Running fdisk and partitioning the drives"
grep -v "^#" < ${fdiskCmdFile} | fdisk "${targetDev}"

echo "Creating EFI filesystem on ${efiPart}"
# make filesystem on efi
mkfs.fat -F32 "${efiPart}"

echo "Creating root filesystem on ${rootPart}"
# create the root filesystem
mkfs.ext4 "${rootPart}"


echo "Selecting the best mirrors"
pacman -Syy
pacman -S reflector
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
reflector -c "US" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist


echo "Installing Arch"

echo "Mounting root"
mount "${rootPart}" /mnt

echo "Making /mnt/boot/efi directory"
mkdir /mnt/boot/efi

echo "Mounting EFI"
mount "${efiPart}" /mnt/boot/efi

echo "Installing with pacstrap"
pacstrap /mnt base linux linux-firmware vim dhcpcd

echo "Generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab









