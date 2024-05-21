echo "Starting Arch Linux installation..."

# Set the keyboard layout
loadkeys us

# Verify the boot mode
ls /sys/firmware/efi/efivars

# Update the system clock
timedatectl set-ntp true

# Partition the disks
fdisk /dev/sda

# Format the partitions
mkfs.ext4 /dev/sda1
mkfs.fat -F32 /dev/sda2

# Mount the file systems
mount /dev/sda1 /mnt
mkdir /mnt/boot
mount /dev/sda2 /mnt/boot

# Install essential packages
pacstrap /mnt base linux linux-firmware

# Configure the system
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

# Set the time zone
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc

# Localization
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Network configuration
echo "myhostname" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 myhostname.localdomain myhostname" >> /etc/hosts

# Set root password
echo "Set root password"
passwd

# Install a bootloader
pacman -S grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Install Xorg and other utilities
pacman -S xorg xorg-xinit xorg-server xterm

# Install dwm
pacman -S git base-devel
git clone https://git.suckless.org/dwm /opt/dwm
cd /opt/dwm
make clean install

# Set up .xinitrc to start dwm
echo "exec dwm" > ~/.xinitrc

# Exit chroot
exit

# Unmount all partitions
umount -R /mnt

echo "Arch Linux with dwm is installed. Please reboot your computer."

