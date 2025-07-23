
echo "Enter usr name"
read usr

echo "Enter usr password"
read passwd

echo "Enter root passwd" 
read root

echo "Enter hostname"
read hostname

# make filesystems
echo "-------------------------"
echo "--CREATING FILE SYSTEMS--"
echo "-------------------------"
mkfs.fat -F -32 /dev/sda1 
mkswap /dev/sda2
mkfs.exte4 /dev/sda3
mkdir -p /mnt/boot/efi


# mount filesystems
echo "-------------------------"
echo "---MOUNTING PARTITIONS---"
echo "-------------------------"
mount /dev/sda1 /mnt/boot/efi 
swapon /dev/sda2 
mount /dev/sda3 /mnt

#installing base packages
echo "-------------------------"
echo "-INSTALLING BASE SYSTEM--"
echo "-------------------------"
pacstrap /mnt base linux linux-firmware sudo nano grub networkmanager efibootmgr sof-firmware base-devel

#genfstab
genfstab /mnt > /mnt/etc/fstab

#add usr 
usr add -m -G wheel -s /bin/bash $usr
echo $hostname >> /etc/hostname
passwd $usr $passwd
passwd $root

sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

#locale config 
echo "-------------------------"
echo "---CONFIGUREING LOCALE---"
echo "-------------------------"

ln -sf /usr/share/zoneinfo/America/Chicago /etc/localetime 
hwclock --systohc 

echo "LANG=en_US.UTF-8" >> /etc/locale.conf

systemctl enable NetworkManager

echo "-------------------------"
echo "----INSTALL COMPLETE-----"
echo "-------------------------"
