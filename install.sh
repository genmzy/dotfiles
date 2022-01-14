#!/bin/zsh

source ~/.zshrc

# if empty $1, exiting
if [[ "X$1" == "X" ]]; then
    echo "empty sudo password, exiting..."
    exit 1
fi

echo "checking password correct or not ..."
echo $1 | sudo -S echo "correct!"
if [ $? -ne 0 ]; then
    echo "incorrect password, exiting"
    exit 1
fi

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
if [ $? -ne 0 ]; then
    echo "curl for vim-plug failed, exiting ... "
    exit 1
fi

echo $1 | sudo -S sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list
echo $1 | sudo -S apt install apt-fast
if [ $? -ne 0 ]; then
    echo "install apt-fast failed, exiting ... "
    exit 1
fi

/bin/mkdir /mnt/c/Users/waves/Pictures/pokemon/Generation\ IV\ -\ Sinnoh/ -p
/bin/cp ./background/448.jpg /mnt/c/Users/waves/Pictures/pokemon/Generation\ IV\ -\ Sinnoh/448.jpg
if [ $? -ne 0 ]; then
    echo "cp picture file failed, exiting ... "
    exit 1
fi

echo $1 | sudo -S apt-fast install lazygit bat ccat silversearcher-ag ripgrep lolcat htop ranger bear gcc make cmake curl tree neofetch git lua5.1 lua5.2 maven net-tools python3 pip

~/.config/scripts/pip_update.py
pip install pynvim neovim neovim-remote

echo "Ok, now, you need to install:"
echo "\tnode, npm, golang, freeswitch, opensips, java(maybe) manually"
