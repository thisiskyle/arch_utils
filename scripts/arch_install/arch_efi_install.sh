#!/bin/bash

# this function asks the user for a partition number,
# verfies that the value is numerical, then returns it or asks again
ask_for_num() {
    reg="^[0-9]+$"
    echo -n "Enter number: " >&2
    read n
    while ! [[ $n =~ $reg ]]; do
        echo -n "Response must be a number: " >&2
        read n
    done
    echo $n
}


archChrootScript="/mnt/root/temp.sh"


# set the time protocol
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
fdiskCmdFile="${HOME}/arch_util/data/fdisk/${fdiskCmdFilename}.txt"

# couldnt find fdisk command file
if ! [[ -f "${fdiskCmdFile}" ]]; then
    echo "${fdiskCmdFile} not found"
    exit 1
fi

# inform the user
echo "Assuming this is a simple EFI install and based on the fdisk command file you chose..."

# ask the user for efi partition number
echo "What partition will be EFI?"
efiPartitionNum=$(ask_for_num)

# ask user for root partition number
echo "What partition will be root?"
rootPartitionNum=$(ask_for_num)

# set the full dev partition paths
efiPart="${targetDev}${efiPartitionNum}"
rootPart="${targetDev}${rootPartitionNum}"

# run fdisk
echo "Running fdisk and partitioning the drives"
grep -v "^#" < ${fdiskCmdFile} | fdisk "${targetDev}"

# make filesystem on efi
echo "Creating EFI filesystem on ${efiPart}"
mkfs.fat -F32 "${efiPart}"

# create the root filesystem
echo "Creating root filesystem on ${rootPart}"
mkfs.ext4 "${rootPart}"

# install reflector
echo "Installing reflector"
pacman -Syy
pacman -S reflector

# backup up mirrorlist
echo "Backing up mirrorlist"
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

# create new mirror list
echo "Creating new mirrorlist"
reflector -c "US" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

# mount root partition
echo "Mounting root"
mount "${rootPart}" /mnt

# create efi mount point
echo "Making /mnt/boot/efi directory"
mkdir /mnt/boot/efi

# mount efi partition
echo "Mounting EFI"
mount "${efiPart}" /mnt/boot/efi

# install arch
echo "Installing Arch with pacstrap"
pacstrap /mnt base linux linux-firmware vim dhcpcd base-devel

# generate fstab
echo "Generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab

echo "How large do you want the swapfile? (in GB)"
swap_size=$(ask_for_num)

swap_path="/swapfile"


# TODO/incomplete: arch-chroot stuff here use a cat heredoc or whatever to create a file on the /mnt parition
cat <<EOF > ${archChrootScript}

dd if=/dev/zero of=${swap_path} bs=1G count=${swap_size} status=progress
chmod 600 ${swap_path}
mkswap ${swap_path}
swapon ${swap_path}
echo "${swap_path}  none  swap  defaults  0 0" >> /etc/fstab

ln -sf /usr/share/zoneinfo/America/Detroit /etc/localtime
hwclock --systohc
echo "en_US.UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
export LANG=en_US.UTF-8



locale-gen


EOF


arch-chroot /mnt "${archChrootScript}"





