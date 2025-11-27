#!/bin/bash
## Remove dot files
rm -rf ~/.jupyter
rm ~/.zshrc
rm ~/.bashrc

## Install ubuntu packages
sudo apt-get update -y
sudo apt install wget vim tmux zsh -y


## Install dotfiles
echo "Do you want to install Cape's dotfiles? (yes/no)"
read install_dotfiles
if [ "$install_dotfiles" = "yes" ]; then
    sh install
fi

cd
## Download Miniforge
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh

## Install Anaconda
echo "Installing Anaconda"
chmod +x Miniforge3-Linux-x86_64.sh
sh Miniforge3-Linux-x86_64.sh -bf
~/miniforge3/bin/conda init zsh
~/miniforge3/bin/conda init bash

