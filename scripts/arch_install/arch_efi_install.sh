#!/bin/bash

#
#    This script is for installing arch by itself, on a single harddrive. Whatever device you
#    provide will be erased during this process.
#
#    Partitions are created using mostly hard coded values and a few assumptions. 
#    We assume we only want 2 partitions (1: EFI, 2: root) and we format those partitions accordingly.
#    We also assume that this install will be taking up the entire harddrive
#    
#  


# TODO/feature: Maybe here we can just give a little run down of what is about to happen
#               with some warnings about the partitions and what not


SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)

source "${SCRIPT_DIR}/arch_install.conf"

# get the target device from the user
echo "\n!!!!! WARNING: THIS DEVICE WILL BE COMPLETELY ERASED !!!!!"
echo -n "Target device (ex. /dev/sda): "
read target_dev

# TODO/feature: here, maybe check to make sure that this device exists?
#               then double check with user is this is correct, if not we abort

# ask user for hostname if config did not set it
if [ -z ${target_hostname+x} ]; then
    echo -n "Target hostname: "
    read target_hostname
fi

# if no set, ask user for swapfile size in GB
if [ -z ${swap_size+x} ]; then
    # TODO/improve: maybe we can check the amount of RAM and suggest a swapfile size?
    echo -n "Target swapfile size (GB): "
    read swap_size
fi

# verify that we got a number as a response
reg="^[0-9]+$"
while ! [[ $swap_size =~ $reg ]]; do
    echo -n "Swapfile size must be a number: " >&2
    read swap_size
done

# ask user for local timezone
if [ -z ${local_timezone+x} ]; then
    echo -n "Local timezone (ex. America/Detroit): "
    read local_timezone
fi

# ask user for locale
if [ -z ${locale+x} ]; then
    echo -n "Target Locale (ex. en_US.UTF-8 UTF-8): "
    read locale
fi

# ask user for lang
if [ -z ${lang+x} ]; then
    echo -n "Target lang (ex. en_US.UTF-8): "
    read lang
fi

# if unset, ask for username input
if [ -z ${username+x} ]; then
    echo -n "Target username: "
    read username
fi

# location of the swapfile
swap_path="/swapfile"

# location to save the script that will be used for arch-chroot
arch_chroot_script="temp.sh"

# set the full dev partition paths
efiPart="${target_dev}1"
rootPart="${target_dev}2"

if [ -z ${fdisk_cmd+x} ]; then
    echo "ERROR: fdisk_cmd unset. Aborting"
    exit 1
fi

# unmount the drives
umount -R /mnt
swapoff -a

# set the time protocol
echo "Setting time protocol sync"
timedatectl set-ntp true

# run fdisk
echo "Running fdisk and partitioning the drives"
echo "${fdisk_cmd}" | grep -v "^#" | fdisk "${target_dev}"

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
echo "Making /mnt/efi directory"
mkdir /mnt/efi

# mount efi partition
echo "Mounting EFI"
mount "${efiPart}" /mnt/efi

# install arch
echo "Installing Arch with pacstrap"
pacstrap /mnt base linux linux-firmware vim dhcpcd base-devel

# generate fstab
echo "Generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab

# TODO/incomplete: arch-chroot stuff here use a cat heredoc or whatever to create a file on the /mnt parition
cat <<EOF > /mnt/${arch_chroot_script}

dd if=/dev/zero of=${swap_path} bs=1G count=${swap_size} status=progress
chmod 600 ${swap_path}
mkswap ${swap_path}
swapon ${swap_path}
echo "${swap_path}  none  swap  defaults  0 0" >> /etc/fstab

ln -sf /usr/share/zoneinfo/${local_timezone} /etc/localtime
hwclock --systohc
echo "${locale}" >> /etc/locale.gen
locale-gen

echo "LANG=${lang}" >> /etc/locale.conf
export LANG=${lang}

echo "${target_hostname}" > /etc/hostname

cat << EOF_hosts > /etc/hosts

127.0.0.1  localhost
::1        localhost
127.0.1.1  ${target_hostname}.localdomain ${target_hostname}

EOF_hosts

passwd

pacman -S grub efibootmgr sudo os-prober

grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

useradd -mG wheel ${username}
passwd ${username}

echo "%wheel all=(all) all" >> /etc/sudoers
echo "Defaults env_reset,timestamp_timeout=60" >> /etc/sudoers

exit
EOF

chmod 777 "/mnt/${arch_chroot_script}"

# use arch-chroot to run the rest of our script
arch-chroot /mnt "/${arch_chroot_script}"

# remove the temporary script
rm /mnt/${arch_chroot_script}

# move the setup into the main install so we can finish our setup
cp -R /arch_utils /mnt/home/${username}/

# unmount the drives
umount -R /mnt
swapoff -a
umount -R /mnt

echo "Congrats, your installation (of Arch linux btw) is complete!"
echo "Reboot now"

