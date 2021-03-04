# Get info from the user
hostname=$(dialog --stdout --inputbox "Enter hostname:" 0 0) || exit 1
clear
: ${hostname:?"hostname cannot be empty"}

# User
user=$(dialog --stdout --inputbox "Enter username:" 0 0) || exit 1
clear
: ${user:?"username cannot be empty"}

# Root password
root_password=$(dialog --stdout --passwordbox "Enter root password:" 0 0) || exit 1
clear
: ${root_password:?"password cannot be empty"}
root_password2=$(dialog --stdout --passwordbox "Confirm root password:" 0 0) || exit 1
clear
[[ "$root_password" == "$root_password2" ]] || (echo "Passwords did not match"; exit 1; )

# User password
user_password=$(dialog --stdout --passwordbox "Enter root password:" 0 0) || exit 1
clear
: ${user_password:?"password cannot be empty"}
user_password2=$(dialog --stdout --passwordbox "Confirm root password:" 0 0) || exit 1
clear
[[ "$user_password" == "$user_password2" ]] || (echo "Passwords did not match"; exit 1; )

# Disks
devicelist=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpbmp|loop" | tac)
device=$(dialog --stdout --menu "Select installation disk" 0 0 0 ${devicelist}) || exit 1
clear

# Grub target
grub_target=$(dialog --stdout --inputbox "Enter GRUB target:" 0 0) || exit 1
clear
: ${grub_target:?"GRUB target cannot be empty"}

# set up logging 
exec 1> >(tee "stdout.log")
exec 2> >(tee "stderr.log")

# set the ntp time
timedatectl set-ntp true

# Disk size and partitions
swap_size=$(free --mebi | awk '/Mem:/ {print $2}')
swap_end=$(( $swap_size + 129 + 1 )) M

# Fdisk
fdisk <<FDISK
o
n
p


$swap_end
n
p



w
q
FDISK

# Swap and root partitions
swap_partition="${device}1"
root_partition="${device}2"

mkfs.ext4 "$root_partition"
mkswap "$swap_partition"

# Mount root partition
mount "$root_partition" /mnt

# Activate swap
swapon "$swap_partition"

# Install base system
pacstrap /mnt base linux linux-firmware

# Install utilities
pacstrap /mnt vim networkmanager man-db man-pages tex-info chromium ratpoison sudo

# FSTAB
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into the system
arch-chroot

# Timezone
ln -sf /usr/share/zoneinfo/Africa/Nairobi /etc/localtime
hwclock --systohc

# localization
locale="en_US.UTF-8 UTF-8"
lang="en_US.UTF-8"

echo $locale > /etc/locale.gen
echo $lang > /etc/locale.conf

# Host configuration
hosts="/etc/hosts"
echo ${hostname} > /etc/hostname

(
cat <<HOSTS
127.0.0.1	localhost
::1		localhost
127.0.0.1	"${hostname}".localdomain	"${hostname}"
HOSTS
) > $hosts

# Set root password
passwd <<PWD
${root_password}
${root_password2}
PWD

# Set up second user
useradd -m ${username}

passwd ${username} <<PWD
${user_password}
${user_password2}
PWD

usermod -aG wheel,audio,video,optical,storage ${username}

# Editing sudoers file
sudoers_tmp = $(mktemp)
cat /etc/sudoers >> ${sudoers_tmp}
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' ${sudoers_tmp}
visudo -c -f ${sudoers_tmp} && \
	cat  ${sudoers_tmp} > /etc/sudoers
rm ${sudoers_tmp}

# Install and configure a bootloader
pacman -S grub
grub-install --target=${grub_target} ${device}
grub-mkconfig -o /boot/grub/grub.cfg

# Configure microcode updates
pacman -S intel-ucode
grub-mkconfig -o /boot/grub/grub.cfg
