#!/bin/bash

# get the directory this script is running in
SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)

# source the config file
source "${SCRIPT_DIR}/config"

# get the target device from the user
echo "\n!!!!! WARNING: THIS DEVICE WILL BE COMPLETELY ERASED !!!!!"
read -p "Target device (ex. /dev/sda): " target_dev

# TODO/feature: here, maybe check to make sure that this device exists?

# ask for confirmation that the chosen device is correct
read -p "The target device that will be formatted and partitioned is ${target_dev}, is this correct? (y/n): " user_confirm
user_confirm=${user_confirm:-y}
# check the confirmation
if [[ ${user_confirm,,} != "y" ]] || [[ ${user_confirm,,} != "yes" ]]; then
    echo "Exiting"
    exit 1
fi


# ask user for hostname if config did not set it
if [ -z ${target_hostname+x} ]; then
    read -p "Target hostname: " target_hostname
fi

# if no set, ask user for swapfile size in GB
if [ -z ${swap_size+x} ]; then
    # TODO/improve: maybe we can check the amount of RAM and suggest a swapfile size?
    read -p "Target swapfile size (GB): " swap_size
fi

# verify that we got a number as a response
reg="^[0-9]+$"
while ! [[ $swap_size =~ $reg ]]; do
    read -p "Swapfile size must be a number: " swap_size
done

# ask user for local timezone
if [ -z ${local_timezone+x} ]; then
    read -p "Local timezone (ex. America/Detroit): " local_timezone
fi

# ask user for locale
if [ -z ${locale+x} ]; then
    read -p "Target Locale (ex. en_US.UTF-8 UTF-8): " locale
fi

# ask user for lang
if [ -z ${lang+x} ]; then
    read -p "Target lang (ex. en_US.UTF-8): " lang
fi

# if unset, ask for username input
if [ -z ${username+x} ]; then
    read -p "Target username: " username
fi

# location of the swapfile
swap_path="/swapfile"

# location to save the script that will be used for arch-chroot
arch_chroot_script="temp.sh"

# set the full dev partition paths
esp="${target_dev}1"
rootPart="${target_dev}2"

# unmount the drives
umount -R /mnt
swapoff -a

# set the time protocol
echo "Setting time protocol sync"
timedatectl set-ntp true

# check if the fdisk commands are set from the config
if [ -z ${fdisk_cmd+x} ]; then
    # unset fdisk commands
    read -p "WARNING: fdisk_cmd is unset. Would you like to partition the drive manually? (y/n): " manual_fdisk
    manual_fdisk=${manual_fdisk:-y}

    if [[ ${manual_fdisk,,} == "y" ]] || [[ ${manual_fdisk,,} == "yes" ]]; then
        # run fdisk manually
        fdisk "${target_dev}"
        if [[ ${?} -ne 0 ]]; then
            echo "ERROR: fdisk failed. Exiting"
            exit 1
        fi
    else
        # user doesnt want to manually partition the disks
        echo "Exiting"
        exit 1
    fi
else
    # run automated fdisk
    echo "Running fdisk and partitioning the drives"
    echo "${fdisk_cmd}" | grep -v "^#" | fdisk "${target_dev}"
    if [[ ${?} -ne 0 ]]; then
        echo "ERROR: fdisk failed. Exiting"
        exit 1
    fi
fi

# make filesystem on esp
echo "Creating EFI filesystem on ${esp}"
mkfs.fat -F32 "${esp}"

# create the root filesystem
echo "Creating root filesystem on ${rootPart}"
mkfs.ext4 "${rootPart}"

# install reflector
echo "Installing reflector"
pacman -Syy
pacman -S --noconfirm reflector

# backup up mirrorlist
echo "Backing up mirrorlist"
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

# create new mirror list
echo "Creating new mirrorlist"
reflector -c "US" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

# mount root partition
echo "Mounting root"
mount "${rootPart}" /mnt

# mount esp partition
echo "Mounting EFI"
mount "${esp}" /mnt/boot

# install arch
echo "Installing Arch with pacstrap"
pacstrap /mnt base linux linux-firmware vim dhcpcd base-devel

# generate fstab
echo "Generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab

# this will use a cat heredoc or whatever to create a file on the /mnt parition
# to be run by arch-chroot
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

echo "Enter root password: "
passwd

pacman -S --noconfirm efibootmgr sudo os-prober

bootctl install

cat << EOF_loaderconf > /boot/loader/loader.conf

default arch.conf
timeout 10

EOF_loaderconf


cat << EOF_archconf > /boot/loader/entries/arch.conf

title Arch
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=PARTUUID=$(blkid -s PARTUUID -o value ${esp}) rw nomodeset

EOF_archconf

useradd -mG wheel ${username}
passwd ${username}

echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
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
swapoff -a
umount -R /mnt

echo "Congrats, your installation (of Arch linux btw) is complete!"
echo "Reboot now"

