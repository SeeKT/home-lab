#!/bin/bash
printf "password: "
read -s password

WORKDIR=$HOME/workdir/
if [ ! -d "$WORKDIR" ]; then
    echo "Create $WORKDIR"
    mkdir -p $WORKDIR
fi

SNORTDIR=/opt/snorty

# Install dependencies using apt
echo "Install dependencies using apt"
echo "$password" | sudo -S apt-get update && sudo -S apt-get -y upgrade
sudo -S apt install -y autoconf cmake g++ pkg-config libpcre3 libpcre3-dev zlib1g-dev libpcap-dev libtool check liblzma-dev

# Install libdaq
echo "Install libdaq..."
cd $WORKDIR
wget https://github.com/snort3/libdaq/archive/refs/tags/v3.0.16.tar.gz
tar -zxvf v3.0.16.tar.gz
cd libdaq-3.0.16 && ./bootstrap && ./configure && make && sudo -S make install

# Setting libdaq path
echo "/usr/local/lib" | sudo -S tee /etc/ld.so.conf.d/libdaq3.conf
sudo -S ldconfig
echo "Finish installing libdaq"

# Install libdnet
echo "Install libdnet..."
cd $WORKDIR
wget https://github.com/ofalk/libdnet/archive/refs/tags/libdnet-1.18.0.tar.gz
tar -zxvf libdnet-1.18.0.tar.gz
cd libdnet-libdnet-1.18.0 && ./configure && make && sudo -S make install
echo "Finished installing libdnet"

# Install flex
echo "Install flex..."
cd $WORKDIR
wget https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz
tar -zxvf flex-2.6.4.tar.gz
cd flex-2.6.4 && ./configure && make && sudo -S make install
echo "Finished installing flex"

# Install hwloc
echo "Install hwloc..."
cd $WORKDIR
wget https://download.open-mpi.org/release/hwloc/v2.11/hwloc-2.11.2.tar.gz
tar -zxvf hwloc-2.11.2.tar.gz
cd hwloc-2.11.2 && ./configure && make && sudo -S make install
echo "Finished installing hwloc"

# Install luajit
echo "Install luajit..."
cd $WORKDIR
wget https://github.com/LuaJIT/LuaJIT/archive/refs/tags/v2.1.ROLLING.tar.gz
tar -zxvf v2.1.ROLLING.tar.gz
cd LuaJIT-2.1.ROLLING && make && sudo -S make install
echo "Finished installing luajit"

# Install OpenSSL
echo "Installing OpenSSL"
cd $WORKDIR
wget https://github.com/openssl/openssl/releases/download/openssl-3.3.2/openssl-3.3.2.tar.gz
tar -zxvf openssl-3.3.2.tar.gz
cd openssl-3.3.2 && ./Configure && make && sudo -S make install
echo "Finished installing OpneSSL"

# Build Snort3
echo "Build Snort3..."
cd $WORKDIR
wget https://github.com/snort3/snort3/archive/refs/tags/3.3.5.0.tar.gz
tar -zxvf 3.3.5.0.tar.gz
cd snort3-3.3.5.0 && ./configure_cmake.sh --prefix="$SNORTDIR" && cd build && sudo make -j $(nproc) install
sudo -S ldconfig
echo "Finished building Snort3"
