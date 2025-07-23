#meow nya~

read -p "Enter usr name: " usr
read -p "Enter passwd: " passwd
read -p "Enter root passwd: " root
read -p "Enter hostname: " hstnm

# make filesystems
echo "-------------------------"
echo "--CREATING FILE SYSTEMS--"
echo "-------------------------"
mkfs.fat -F -32 /dev/sda1 
mkswap /dev/sda2
mkfs.ext4 /dev/sda3
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
pacstrap /mnt base linux linux-firmware sudo nano grub networkmanager efibootmgr sof-firmware base-devel -y

#genfstab
genfstab /mnt > /mnt/etc/fstab

#add usr 
usr add -m -G wheel -s /bin/bash $usr
echo $hstnm >> /etc/hostname
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
