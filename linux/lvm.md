
```
sudo vgcreate vgaux /dev/nvme1n1 /dev/sda
sudo vgdisplay
sudo lvcreate -l '100%vg' -n lvaux vgaux
```

```
sudo cryptsetup luksFormat /dev/vgaux/lvaux 
sudo cryptsetup open /dev/vgaux/lvaux aux
sudo mkfs.ext4 /dev/mapper/aux 
sudo cryptsetup luksDump /dev/mapper/vgaux-lvaux 
```

Remove
```
sudo lvremove lvaux
sudo vgremove vgaux
sudo wipefs -a /dev/nvme1n1
sudo wipefs -a /dev/sda

```

Clevis
```
sudo apt-get -y install clevis clevis-tpm2 clevis-luks clevis-initramfs initramfs-tools tss2

LUKSKEY=secret
sudo clevis luks bind -d /dev/vgaux/lvaux tpm2 '{"pcr_bank":"sha256"}' <<< "$LUKSKEY"
sudo  update-initramfs -u -k all

```

Add this to *etc/crypttab*
```
aux_crypt UUID=d9d5bf2e-39ab-4bbc-a013-8cc0f5c0eeb9 none luks,discard
```

You need to enable this
```
sudo systemctl status clevis-luks-askpass.service
```

Links

[LUKS](https://oak-tree.tech/blog/lvm-luks)
