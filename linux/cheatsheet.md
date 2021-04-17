
# Alternatives
```
sudo update-alternatives --get-selections
sudo update-alternatives --remove-all ld
sudo update-alternatives --install /bin/ld ld /usr/bin/x86_64-linux-gnu-ld.gold 20
sudo update-alternatives --install /bin/ld ld /usr/lib/llvm-11/bin/lld 20
sudo update-alternatives --install /bin/ld ld /usr/bin/x86_64-linux-gnu-ld.bfd 20
```

# Grub and Console font
Edit the */etc/default/console-setup* , change FONTSIZE="16x32" run ```update-initramfs-u```

Edit */etc/default/grub* and remove "quiet splash", ```update-grub```

