# Find available kernels
`apt-cache search linux-image`

# Find specific module per kernel
`find /lib/modules -type f -name '*.ko' | grep rbd`

# Find bootable kernels
`awk '/menuentry/ && /class/ {count++; print count-1"****"$0 }' /boot/grub/grub.cfg`

# Update default with X (as per above command)
`sudo sed -i  's/GRUB_DEFAULT=0/GRUB_DEFAULT=X/g' /etc/default/grub; sudo update-grub`