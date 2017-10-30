#!/usr/bin/env bash

set -e

# Install Python 3.6 and the Scipy Stack
cd ~
wget https://repo.continuum.io/archive/Anaconda3-5.0.0.1-Linux-x86_64.sh
bash Anaconda3-5.0.0.1-Linux-x86_64.sh -b
rm Anaconda3-5.0.0.1-Linux-x86_64.sh
echo "export PATH=/root/anaconda3/bin:$PATH" >> ~/.bashrc
echo "export PYTHONPATH=$PYTHONPATH:/root/dependencies/spark-2.2.0-bin-hadoop2.7/python" >> ~/.bashrc
echo "export SPARK_HOME=/root/dependencies/spark-2.2.0-bin-hadoop2.7" >> ~/.bashrc
cat /root/aws-qb-env.sh >> ~/.bashrc

# Install Python dependencies
pip install -r requirements.txt
