#!/bin/bash

# Prevent sudo timeout
sudo -v # ask for sudo password up-front
while true; do
  # Update user's timestamp without running a command
  sudo -nv; sleep 1m
  # Exit when the parent process is not running any more. In fact this loop
  # would be killed anyway after being an orphan(when the parent process
  # exits). But this ensures that and probably exit sooner.
  kill -0 $$ 2>/dev/null || exit
done &

sudo apt update
sudo apt -y install build-essential git cmake libusb-1.0-0-dev lsof libzmq3-dev clang php-cli nodejs gpsd libfftw3-3 libfftw3-dev

git clone https://github.com/krakenrf/librtlsdr
cd librtlsdr
sudo cp rtl-sdr.rules /etc/udev/rules.d/rtl-sdr.rules
mkdir build
cd build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
sudo ln -s ~/librtlsdr/build/src/rtl_test /usr/local/bin/kraken_test

echo 'blacklist dvb_usb_rtl28xxu' | sudo tee --append /etc/modprobe.d/blacklist-dvb_usb_rtl28xxu.conf

cd
git clone https://github.com/krakenrf/kfr
cd kfr
mkdir build
cd build
cmake -DENABLE_CAPI_BUILD=ON -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Release ..
make

sudo cp ~/kfr/build/lib/* /usr/local/lib
sudo mkdir /usr/include/kfr
sudo cp ~/kfr/include/kfr/capi.h /usr/include/kfr
sudo ldconfig

cd
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
chmod ug+x Miniforge3-Linux-x86_64.sh
./Miniforge3-Linux-x86_64.sh -b

export PATH=~/miniforge3/bin/:$PATH
eval "$(conda shell.bash hook)"
conda init bash
conda config --set auto_activate_base false

conda create -y -n kraken python=3.10.8
conda activate kraken

conda install -y scipy==1.9.3
conda install -y numba
conda install -y configparser
conda install -y pyzmq

cd
mkdir krakensdr_doa
cd krakensdr_doa

git clone https://github.com/krakenrf/heimdall_daq_fw
cd heimdall_daq_fw

cd ~/krakensdr_doa/heimdall_daq_fw/Firmware/_daq_core/
cp ~/librtlsdr/build/src/librtlsdr.a .
cp ~/librtlsdr/include/rtl-sdr.h .
cp ~/librtlsdr/include/rtl-sdr_export.h .
make

conda install -y pandas
conda install -y orjson
conda install -y matplotlib
conda install -y requests
conda install -y scikit-image
conda install -y scikit-rf

pip3 install dash_bootstrap_components==1.1.0
pip3 install quart_compress==0.2.1
pip3 install quart==0.17.0
pip3 install dash_devices==0.1.3
pip3 install pyargus
pip3 install gpsd-py3

conda install -y dash==1.20.0
conda install -y werkzeug==2.0.2

conda install -y "blas=*=mkl"
conda install -y numba
conda install -y -c numba icc_rt

cd 

cd ~/krakensdr_doa
git clone https://github.com/krakenrf/krakensdr_doa
cp krakensdr_doa/util/kraken_doa_start.sh .
cp krakensdr_doa/util/kraken_doa_stop.sh .
