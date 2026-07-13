# After Ubuntu install

<!--toc:start-->
- [After Ubuntu install](#after-ubuntu-install)
<!--toc:end-->

- Net proxy

``` bash
mkdir ~/App
cp -r ./Backup/FlClash ~/App/
# run App/FlClash/FlClash-0.8.84-linux-amd64.AppImage
# Add profile and chose node
```

- Apt sources

``` plain
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
sudo apt-fast install bat ccat silversearcher-ag ripgrep lolcat \
  htop ranger bear gcc make cmake curl tree neofetch git lua5.1 \
  lua5.2 maven net-tools python3 pip
```

- Do copy

``` bash
cp -r ./.config/* ~/.config/
cp -r ./.cargo ~/
cp -r ./.gitconfig

# cp -r ./.pip ~/.pip # ignore this since ubuntu24.04 use apt instead of pip

mkdir ~/.local/share/fonts/ && \
  cp -r ./Backup/LXGWWenKaiMono/* ./Backup/comicNFv3/* ~/.local/share/fonts/
cp ./.zshrc ~/
cp ./.npmrc ~/
cp ./.pam_environment ~/

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# restart zsh
```

- Git configuration

``` bash
git config --global credential.helper store
git config --global user.name "genmzy"
git config --global user.email "986299679@qq.com"
```

- Set keyboard interval for gtk

``` bash
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 20 && \
  gsettings set org.gnome.desktop.peripherals.keyboard delay 200
```

- Niri/DMS do not need this

- Input method

- use fcitx5 as input method, and do not forget copy file **.pam_environment** above

- Update: as use niri now, do not need `.pam_environment`
- Use *rime* instead of *pinyin*:
  - Need to install another packet: `sudo apt install fcitx5-rime`
  - Use [frost](https://github.com/gaboolic/rime-frost) input:
    - Download and unzip to frost: `mkdir rime && mv rime-frost-schemas.zip rime & cd rime && unzip ./rime-frost-schemas.zip`
    - Move the directory to fcitx5: `rm -fr ~/.local/share/rime && mv ./rime ~/.local/share/fcitx5/`

- Gnome beautify

``` bash
sudo apt install ubuntu-desktop
# mouse right-click and chose `Change Background` and set color to Blue

git clone https://github.com/vinceliuice/WhiteSur-gtk-theme --depth=1
cd WhiteSur-gtk-theme && ./install.sh -o solid -c light -l && \
  sudo ./tweaks.sh -g -b "/usr/share/backgrounds/Monument_valley_by_orbitelambda.jpg"

cd ../
git clone https://github.com/vinceliuice/WhiteSur-icon-theme --depth=1
cd WhiteSur-icon-theme && ./install.sh -b

```

- Shortcut conflict
  - Keyboard custom shortcut config change alt+space to ctrl+shift+space
  - Fcitx5 trigger-input-method only keep control+space, not left-shift
  - Fcitx5 change default-previous-page to `-` and default-next-page to `=`
  - Fcitx5-addon - input-method - keyboard delete trigger-hint-mode and trigger-hint-mode-for-one-time

# Dank-Meterial-Shell Linux based on ubuntu

- require `ubuntu >= 25.10`
- install niri and dsm

``` bash
sudo add-apt-repository ppa:avengemedia/danklinux
sudo add-apt-repository ppa:avengemedia/dms
sudo apt update
sudo apt install niri dms
```

- after install, use niri `wip/branch` branch build **niri** binary replacing with `/usr/bin/niri` for blur effect
- should install `brightnessctl` and `wpctl` to control brightness and voice with keyboard, besides, should add user to group **video** like: `sudo usermod -aG video genmzy`
- ~~[wallpapers](https://github.com/genmzy/catppuccin-wallpapers)~~ update: .config/wallpapers

## problem fix

- [x] lazygit with the configuration in this repo failed when `<esc>` quit, should use earlier version lazygit instead:

```
go install github.com/jesseduffield/lazygit@v0.47.0
```

- [ ] rime <c-space> typing makes enter the first of listed, not letters

## firefox fullwindow but not full-monitor

- useful when want full-window video playing.
- enter `about:config` on search bar.
- set `full-screen-api.ignore-widgets` to `true`, now **F11** will works.
- if want to real-full screen like before, use `Mod+Shift+f` instead of `Mod+f`(maxmize) to make window full screen

## steam cannot display but a black screen

- find snapd steam desktop file locaiton: `/var/lib/snapd/desktop/applications/steam_steam.desktop`
- change `Exec` line and add paramter: `-system-composer`

## firefox change all window zoom

- `about:config` search `layout.css.devPixelsPerPx` change to `1.1` `1.3`.

## Neovim new dependencies

- find `tree-sitter-cli` from `treesitter` repository

# change the default qt-ui app font size like *okular*

- `sudo apt install qt5ct qt6ct`
- add `QT_QPA_PLATFORMTHEME "qt5ct"` to environment settings of niri configuration file(added in this repo)
- open app `QT5 Settings` and change the font size

# GMS Greeter

- copy `./.local/share/icons/breeze_cursors` to `/usr/share/icons/` instead of `~/.local/share/icons/`
- `sudo apt install dms-greeter`
- `dms greeter enable`
- `dms greeter sync`

# Fingerprint

- `sudo apt install fprintd libpam-fprintd`
- `fprintd-enroll $USER`
- lock screen: open dms and search `fingerprint` and enable that (need install dms-greeter and enable it like above)
- login: edit `/etc/pam.d/greetd`(greetd is in used by dms-greeter) and add at the top of the file:

```
auth         sufficient      pam_fprintd.so
```

# Battery Preserving && Performance

- close default battery manage: `systemctl stop upower` or `systemctl stop power-profiles-daemon`
- cli: `sudo apt install tlp tlp-rdw`
- install tlp and `systemctl enable it` after edit `/etc/tlp.conf` and edit with:
  - AC and battery: `PLATFORM_PROFILE_ON_AC=performance` and `PLATFORM_PROFILE_ON_BAT=low-power`
  - set AC performance `CPU_ENERGY_PERF_POLICY_ON_AC=performance`
  - set battery charge condition, it depends on hardware not support free customize threshold and limit of battery:
    - unsupport: `STOP_CHARGE_THRESH_BAT0=1` (like thinkbook-16p, limittion: 75-80, `sudo tlp-status -b` will check that)
    - support: `START_CHARGE_THRESH_BAT0=55` and `STOP_CHARGE_THRESH_BAT0=70`
- CPU set to performance by changing the kernel paramters on grub:
  - /etc/default/grub: `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash cpufreq.default_governor=performance"`, most often, just add:
    `cpufreq.default_governor=performance`
  - check with: `sudo tlp-stat -p`

# Nvidia Graphics card Settings

- clean all installed nvidia driver`sudo apt purge "^nvidia-.*" "^libnvidia-.*"`
- use ubuntu-drivers to install: `sudo ubuntu-drivers install`
- check `nvidia-smi`
- open **Nvidia X Server Settings** and set nvidia to performance while use AC
- reboot system
- install `nvtop` to see gpu-memmory.
- use GPU for specific app like game engine love, should set: `__NV_PRIME_RENDER_OFFLOAD=1` and `__GLX_VENDOR_LIBRARY_NAME=nvidia`

# Entertainment

- steam: use `snap install steam` after graphics card settled
- heroic:
  - `sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0` to make heoric can start correctly
  - make sure that *FlClash* and proxy started
  - download heroic and change the name to `Heroic-linux-x86_64.AppImage`
  - set *.desktop* startup, make sure the desktop file `Exec` set proxy variables (desktop file already in THIS repository)
  - start heroic and download `GE-Proton-latest` on *Wine Manager*

# System freeze

- please use apt-steam instead of snap-steam, which will make system-wide freeze
- for linux, NVMe PCIE disk should use schedule `none` instead of others
  - check: cat `/sys/block/nvme0n1/queue/scheduler`
  - instantly: `echo none | sudo tee /sys/block/nvme0n1/queue/scheduler` for linux.
  - permanently: edit `/etc/udev/rules.d/60-nvme-scheduler.rules` with `ACTION=="add|change", KERNEL=="nvme0n1", ATTR{queue/scheduler}="none"`
