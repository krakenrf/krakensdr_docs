#!/bin/bash
sudo apt update
sudo apt -y install build-essential git cmake libusb-1.0-0-dev lsof libzmq3-dev clang php-cli nodejs gpsd

git clone https://github.com/krakenrf/librtlsdr
cd librtlsdr
mkdir build
cd build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
sudo make install
sudo ldconfig

echo 'blacklist dvb_usb_rtl28xxu' | sudo tee --append /etc/modprobe.d/blacklist-dvb_usb_rtl28xxu.conf

git clone https://github.com/krakenrf/Ne10
cd Ne10
mkdir build
cd build
cmake -DNE10_LINUX_TARGET_ARCH=aarch64 -DGNULINUX_PLATFORM=ON -DCMAKE_C_FLAGS="-mcpu=native -Ofast -funsafe-math-optimizations" ..
make

cd
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-aarch64.sh
chmod ug+x Miniforge3-Linux-aarch64.sh
./Miniforge3-Linux-aarch64.sh -b

export PATH=~/miniforge3/bin/:$PATH
eval "$(conda shell.bash hook)"
conda init bash
conda config --set auto_activate_base false

conda create -y -n kraken python=3.9.7
conda activate kraken

conda install -y scipy
conda install -y numba
conda install -y configparser
conda install -y pyzmq
conda install -y scikit-rf

cd
mkdir krakensdr_doa
cd krakensdr_doa

git clone https://github.com/krakenrf/heimdall_daq_fw
cd heimdall_daq_fw

cd ~/krakensdr_doa/heimdall_daq_fw/Firmware/_daq_core/
cp ~/Ne10/build/modules/libNE10.a .
make

conda install -y pandas
conda install -y orjson
conda install -y matplotlib
conda install -y requests

pip3 install dash_bootstrap_components==1.1.0
pip3 install quart_compress==0.2.1
pip3 install quart==0.17.0
pip3 install dash_devices==0.1.3
pip3 install pyargus

conda install -y dash==1.20.0
conda install -y werkzeug==2.0.2

cd 

cd ~/krakensdr_doa
git clone https://github.com/krakenrf/krakensdr_doa
cp krakensdr_doa/util/kraken_doa_start.sh .
cp krakensdr_doa/util/kraken_doa_stop.sh .

sudo apt -y install libfftw3-3 libfftw3-dev
pip3 install pyapril
pip3 install cython
pip3 install pyfftw

cd
mkdir krakensdr_pr
cd krakensdr_pr
cp -r ~/krakensdr_doa/heimdall_daq_fw .
git clone https://github.com/krakenrf/krakensdr_pr
cp krakensdr_pr/util/kraken_pr_start.sh .
cp krakensdr_pr/util/kraken_pr_stop.sh .
cp heimdall_daq_fw/config_files/pr_2ch_2pow21/daq_chain_config.ini heimdall_daq_fw/Firmware/daq_chain_config.ini

sudo reboot