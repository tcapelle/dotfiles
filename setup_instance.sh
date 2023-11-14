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
./Miniforge3-Linux-x86_64.sh -b
source ~/.bashrc
conda init zsh
conda init bash

# Create PyTorch env
echo "Creating a PyTorch Env"
conda create -n pt python=3.10
conda activate pt
conda install pytorch torchvision torchaudio cudatoolkit=10.2 jupyterlab -c pytorch -y
