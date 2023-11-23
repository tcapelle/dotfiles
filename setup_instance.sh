#!/bin/bash
## Remove dot files
rm -rf ~/.jupyter
rm ~/.zshrc
rm ~/.bashrc

## Install ubuntu packages
sudo apt-get update -y
sudo apt install wget vim tmux zsh -y

## Paste SSH Key
echo "Please paste your SSH key (finish by typing ';')"

ssh_key=""
line=""

while [[ "$line" != ";" ]]; do
    read line
    ssh_key+="$line"
    ssh_key+=$'\n'
done

# Trimming the ending semicolon and new line from ssh_key
ssh_key=${ssh_key%;$'\n'}

if [[ -n "$ssh_key" ]]; then
    echo -e "$ssh_key" > ~/.ssh/id_cape
    chmod 600 ~/.ssh/id_cape
    echo "SSH key has been stored in ~/.ssh/id_cape with the right permissions."
else
    echo "No SSH key was provided."
fi



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
source ~/.bashrc
~/miniforge3/bin/conda init zsh
~/miniforge3/bin/conda init bash
source ~/.bashrc

# Create PyTorch env
echo "Creating a PyTorch Env"
conda create -n pt "python<3.11"
conda activate pt
python -m pip install torch torchvision packaging
python -m pip install transformers datasets peft bitsandbytes jupyterlab wandb ninja

# Install Flash Attention from tri-dao
echo "==========================================="
echo "Do you want to install flash_attn? (yes/no)"
read install_flash
if [ "$install_flash" = "yes" ]; then
    echo "This may take 3~5 minutes"
    python -m pip install flash-attn --no-cache --no-build-isolation
fi
echo "Checking that everything went well"
python -c "import torch; print(torch.cuda.is_available())"
