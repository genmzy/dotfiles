# After Ubuntu install

- Net proxy
``` shell
mkdir ~/App
cp -r ./Backup/FlClash ~/App/
# run App/FlClash/FlClash-0.8.84-linux-amd64.AppImage
# Add profile and chose node
```

- Apt sources
```
# /etc/apt/sources.list.d/ubuntu.sources

Types: deb
URIs: http://mirrors.aliyun.com/ubuntu/
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: http://mirrors.aliyun.com/ubuntu/
Suites: noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg


sudo add-apt-repository ppa:apt-fast/stable
sudo apt update && sudo apt-fast upgrade
sudo apt-fast install bat ccat silversearcher-ag ripgrep lolcat htop ranger bear gcc make cmake curl tree neofetch git lua5.1 lua5.2 maven net-tools python3 pip
```

- Do copy
```shell

cp -r ./.config/* ~/.config/
cp -r ./.cargo ~/
cp -r ./.gitconfig

# cp -r ./.pip ~/.pip # ignore this since ubuntu24.04 use apt instead of pip

mkdir ~/.local/share/fonts/ && cp -r ./Backup/LXGWWenKaiMono/* ./Backup/comicNFv3/* ~/.local/share/fonts/
cp ./.zshrc ~/
cp ./.npmrc ~/
cp ./.pam_environment ~/

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# restart zsh
```

- Git configuration
``` shell

git config --global credential.helper store
git config --global user.name "genmzy"
git config --global user.email "986299679@qq.com"
```

- Set keyboard interval
```shell
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30 && gsettings set org.gnome.desktop.peripherals.keyboard delay 250
```

- Input method
```
# use fcitx5 as input method, and do not forget copy file **.pam_environment** above
```

- Gnome beautify
```shell
sudo apt install ubuntu-desktop
# mouse right-click and chose `Change Background` and set color to Blue

git clone https://github.com/vinceliuice/WhiteSur-gtk-theme --depth=1
cd WhiteSur-gtk-theme && ./install.sh -o solid -c light -l && sudo ./tweaks.sh -g -b "/usr/share/backgrounds/Monument_valley_by_orbitelambda.jpg"

cd ../
git clone https://github.com/vinceliuice/WhiteSur-icon-theme --depth=1
cd WhiteSur-icon-theme && ./install.sh -b

```
