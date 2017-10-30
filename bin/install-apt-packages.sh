#!/usr/bin/env bash

set -e

apt-get update
apt-get upgrade -y
apt-get remove -y python-setuptools
apt-get install -y build-essential cmake swig python-software-properties
apt-get install -y git wget vim tmux unzip
apt-get install -y libboost-program-options-dev libboost-python-dev libtool libboost-all-dev
apt-get install -y liblzma-dev libpq-dev liblz4-tool zlib1g-dev
apt-get install -y docker.io

apt-get install -y default-jre default-jdk
cat /home/ubuntu/environment | tee --append /etc/environment

# Install LaTeX for reporting
apt-get install -y texlive-latex-base texlive-latex-extra texlive-fonts-extra texlive-fonts-recommended
apt-get install -y pdftk poppler-utils
