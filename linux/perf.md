## Ubuntu Debug symbols and source

[install repo](https://wiki.ubuntu.com/Debug%20Symbol%20Packages)

```
sudo apt-get install linux-image-$(uname -r)-dbgsym linux-source
```

Unpack sources and create a link

```
mkdir -p ~/src/ubuntu-linux-source
tar xvf /usr/src/linux-source-5.8.0.tar.bz2 -C ubuntu-linux-source
sudo ln -s ~/src  /home/<USER>/src/ubuntu-linux-source
```

## Perf


```
# show source
perf probe -L __sys_bind -s ~/src

# add probe (fd is arg1 in %rdi - no r)
perf probe  '__sys_bind fd %di'

# check probe
perf probe -l
cat /sys/kernel/debug/kprobes/list 

# record
perf record -e probe:__sys_bind -aR 

# report
perf script


# remove probe
perf prove --del probe:
```


## BPF

BCC
```
git clone https://github.com/iovisor/bcc.git 
mkdir bcc/build && cd bcc/build
cmake -DCMAKE_INSTALL_PREFIX=/opt/trace/bcc -DCMAKE_BUILD_TYPE=Release -G Ninja  ..
ninja && sudo ninja install
```

BPFTRACE
```
git clone https://github.com/iovisor/bpftrace
mkdir bpftrace/build && cd bpftrace/build
sudo apt install -y libcereal-dev libgtest-dev libgmock-dev asciidoctor
cmake -DCMAKE_INSTALL_PREFIX=/opt/trace/bpftrace -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/opt/trace/bcc -G Ninja  ..
```
