#!/bin/bash
sudo apt update
sudo apt -y install build-essential git cmake libusb-1.0-0-dev lsof libzmq3-dev clang php-cli nodejs gpsd libfftw3-3 libfftw3-dev

# Remove any old librtlsdr installs (NOTE: this could break other RTL-SDR programs if they were relying on a specific driver branch)
#sudo apt purge librtlsdr*
#sudo rm -rvf /usr/lib/librtlsdr* /usr/include/rtl-sdr* /usr/local/lib/librtlsdr* /usr/local/include/rtl-sdr*

git clone https://github.com/krakenrf/librtlsdr
cd librtlsdr
sudo cp rtl-sdr.rules /etc/udev/rules.d/rtl-sdr.rules
mkdir build
cd build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
sudo ln -s src/rtl_test /usr/local/bin/kraken_test

echo 'blacklist dvb_usb_rtl28xxu' | sudo tee --append /etc/modprobe.d/blacklist-dvb_usb_rtl28xxu.conf

#sudo make install
#sudo ldconfig

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
git checkout install_script_test

cd ~/krakensdr_doa/heimdall_daq_fw/Firmware/_daq_core/
cp ~/librtlsdr/build/src/librtlsdr.a .
cp ~/librtlsdr/include/rtl-sdr.h .
cp ~/librtlsdr/include/rtl-sdr_export.h .
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
