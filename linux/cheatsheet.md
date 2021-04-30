
# Alternatives
```
sudo update-alternatives --get-selections
sudo update-alternatives --remove-all ld
sudo update-alternatives --install /bin/ld ld /usr/bin/x86_64-linux-gnu-ld.gold 20
sudo update-alternatives --install /bin/ld ld /usr/lib/llvm-11/bin/lld 20
sudo update-alternatives --install /bin/ld ld /usr/bin/x86_64-linux-gnu-ld.bfd 20
```

# Grub and Console font
Edit the */etc/default/console-setup* , change FONTSIZE="16x32" run ```update-initramfs -u```

Edit */etc/default/grub* and remove "quiet splash", ```update-grub```


# strace

strace -Tfe trace=network,ipc,file,signal,desc -o /tmp/log ./program

# socat

socat -v UNIX-LISTEN:/tmp/mysocket,fork exec:'/bin/cat'

# ip

ip -s -s neigh flush all

iptables -t mangle -o eth1 -A OUTPUT -j MARK --set-mark 1


# vscode

Debug sudo programs 
sudo setcap cap_net_admin,cap_net_raw,cap_sys_admin,cap_sys_ptrace+ep /home/ubuser/.vscode/extensions/vadimcn.vscode-lldb-1.6.2/lldb/bin/lldb-server
