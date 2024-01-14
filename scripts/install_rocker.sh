#!/bin/bash

# Install python3's venv module
sudo apt-get install python3-venv

# Create a virtual environment
mkdir ./rocker_venv
python3 -m venv ./rocker_venv

# Activate the virtual environment
. ./rocker_venv/bin/activate

# Install rocker
pip install wheel
pip install git+https://github.com/osrf/rocker.git
