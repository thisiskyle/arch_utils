## Arch Installer

### About

This script is for installing Arch Linux, by itself, on a single harddrive, in UEFI mode.
Be sure to read the rest of this README and take a look at ```config_example``` before you begin.

This script was built following the process provided on the [Arch Installation Guide](https://wiki.archlinux.org/title/installation_guide) with a few added tweaks.

---

### More Info

- Currently this script assumes we are install Arch in UEFI mode. With a few modifications to this script
  you could probably make it work in BIOS mode as well, but I dont have the need to so I haven't done that.

- Whatever device you provide to the script will be completely erased during partitioning.

- Since this script is build for a UEFI install: 
    - make sure your installation media is booted into UEFI mode
    - make sure you use GPT when partitioning

- Arch will be installed with the following:
    - systemd-boot as the bootloader
    - ESP mountpoint will be ```/boot```
    - we are installing in UEFI mode
    - a swapfile at ```/swap```

---

### Installation

Once loaded into your installion media, you should be able to install ```git``` and clone this repo.

---

### Usage

You can run the script with ```path/to/script/arch_efi_install.sh```

When this script runs you will first be prompted to input your target device name. This device will be 
completely erased during the install process!! To minimize room for error, you cannot set this value in the config.
And will be prompted for it everytime.

This script attempts to source a file in the same directory named ```config``` to set values.
You can make a copy of ```config_example``` and change the values to meet your needs. 
If ```config``` does not exist, or specific values are not set, you will be prompted 
to input the values during the process.

Make sure when looking at the config that you take note of the fdisk commands. 
It's a bit hacky but this section will automate partitioning for you. 
You are welcome to delete this setting entirely and you will be prompted if you want to partition manually using fdisk.
