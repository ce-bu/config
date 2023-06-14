
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

## QtCreator

Debug with caps
sudo setcap cap_net_admin,cap_net_raw,cap_sys_admin,cap_sys_ptrace,,cap_dac_read_search+ep  /opt/bin/llvm-10.0.1/bin/lldb /opt/bin/llvm-10.0.1/bin/lldb-server

## vscode

Debug sudo programs 
sudo setcap cap_net_admin,cap_net_raw,cap_sys_admin,cap_sys_ptrace+ep /home/ubuser/.vscode/extensions/vadimcn.vscode-lldb-1.6.2/lldb/bin/lldb-server

## ftrace
cd /sys/kernel/debug/tracing
echo function > current_tracer

## idris
stack install idris --resolver lts-12.26

## wireshark

sudo groupadd wireshark
sudo usermod -a -G wireshark $USER
sudo chgrp wireshark /usr/bin/dumpcap
sudo chmod o-rx /usr/bin/dumpcap
sudo setcap 'CAP_NET_RAW+eip CAP_NET_ADMIN+eip' /usr/bin/dumpcap
sudo getcap /usr/bin/dumpcap


## Finders

```
# Modules
for m in $(find /lib/modules/$(uname -r) -name "nf_*" -exec basename {} \; | sed -e 's/\..*//g'); do modprobe $m; done
```


## Install a custom Python distro
```
sudo apt install -y tcl-dev tk-dev expat
git clone https://github.com/python/cpython --branch v3.9.6 && cd cpython
./configure --prefix=/opt/python39  --enable-shared --enable-loadable-sqlite-extensions --with-ensurepip=install --enable-optimizations
make -j 12
patchelf --set-rpath '$ORIGIN/../lib' python
sudo make install
```

## Install LLVM 10

```
git clone https://github.com/llvm/llvm-project.git --branch llvmorg-10.0.1
cd llvm-project && mkdir build && cd build && echo $(pwd)
CC=gcc CXX=g++ cmake -DCMAKE_INSTALL_PREFIX=/opt/llvm-10.0.1 -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_ENABLE_Z3_SOLVER=OFF -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;compiler-rt;libc;libcxx;libcxxabi;libunwind;lld;lldb;poly;parallel-libs" -DCMAKE_BUILD_TYPE=Release -G Ninja ../llvm && ninja && sudo ninja install
```


## NFS

Server (/etc/exports) map everything to oe user
```
/home 10.0.0.3/24(rw,sync,all_squash,insecure,anonuid=1000)
firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=mountd
firewall-cmd --permanent --add-service=rpc-bind
systemctl restart firewalld

```
Client:
```
sudo mount -t 10.0.0.3:/home /mnt/rh
```


## SED

```
# display process starttime

starttime()
{
    echo $(cat /proc/$1/stat | sed -e 's/(.[^)]*)/x/' | cut -d ' ' -f 22)    
}
```



