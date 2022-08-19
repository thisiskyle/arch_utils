#!/bin/bash

#
#    This script is for installing arch by itself, on a single harddrive. Whatever device you
#    provide will be erased during this process.
#
#    Partitions are created using mostly hard coded values and a few assumptions. 
#    We assume we only want 2 partitions (1: EFI, 2: root) and we format those partitions accordingly.
#    We also assume that this install will be taking up the entire harddrive
#    
#    Maybe one day I can make this more flexible with a config file or something
#    but for now, this meets my needs.
#  


# TODO/feature: Maybe here we can just give a little run down of what is about to happen
#               with some warnings about the partitions and what not

# get the target device from the user
echo "\n!!!!! WARNING: THIS DEVICE WILL BE COMPLETELY ERASED !!!!!"
echo -n "Target device (ex. /dev/sda): "
read target_dev

# TODO/feature: here, maybe check to make sure that this device exists?
#               then double check with user is this is correct, if not we abort

# TODO/improve: here maybe we check if a file path to a config file was provided
#               then check if it exists, we cant find one, then we can ask the questions
#               otherwise, just use the config that was provided


# ask user for hostname
echo -n "Target hostname: "
read target_hostname

# ask user for swapfile size in GB
# TODO/improve: maybe we can check the amount of RAM and suggest a swapfile size?
echo -n "Target swapfile size (GB): "
read swap_size

# verify that we got a number as a response
reg="^[0-9]+$"
while ! [[ $swap_size =~ $reg ]]; do
    echo -n "Swapfile size must be a number: " >&2
    read swap_size
done

# ask user for local timezone
echo -n "Local timezone (ex. America/Detroit): "
read local_timezone

# ask user for locale
echo -n "Target Locale (ex. en_US.UTF-8): "
read locale

echo -n "Target username: "
read username

# location of the swapfile
swap_path="/swapfile"

# location to save the script that will be used for arch-chroot
arch_chroot_script="/root/temp.sh"

# set the full dev partition paths
efiPart="${target_dev}1"
rootPart="${target_dev}2"

# There are the commands to be sent to fdisk for partitioning
# you can use '#' for comments, comments must start on a new line
# newlines are the same as hitting 'enter' so white space matters
fdisk_cmd=$(cat << EOF
# clear the in memory partition table
o
# new partition
n
# primary partition
p
# partition number
1
# hit enter to select default, start at beginning of disk 

# size of EFI parttion
+1024M
# set partition type to EFI
t
ef
# new partition
n
# primary partition
p
# partion number
2
# hit enter to select default, start immediately after preceding partition

# hit enter to select default, extend partition to end of disk

# write the partition table
w
# and we're done
q

EOF
)

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
echo "LANG=${locale}" >> /etc/locale.conf
export LANG=${locale}
locale-gen

echo "${target_hostname}" > /etc/hostname

cat << EOF > /etc/hosts

127.0.0.1  localhost
::1        localhost
127.0.1.1  ${target_hostname}.localdomain ${target_hostname}

EOF

passwd

pacman -S grub efibootmgr sudo os-prober

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

useradd -mG wheel ${username}
passwd ${username}

echo "%wheel all=(all) all" >> /etc/sudoers
echo "Defaults env_reset,timestamp_timeout=60" >> /etc/sudoers

exit
EOF

# use arch-chroot to run the rest of our script
arch-chroot /mnt "${arch_chroot_script}"
# remove the temporary script
rm /mnt/${arch_chroot_install}
# move the setup into the main install so we can finish our setup
cp -R /arch-setup /mnt/home/${username}/arch-setup/

# unmount the drives
umount /mnt/boot/efi
umount /mnt

echo "Congrats, your installation (of Arch linux btw) is complete!"
echo "Reboot now"

