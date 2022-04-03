# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export NODE_PATH=/usr/local/lib/node_modules/
#export GIT_SSL_NO_VERIFY=1

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="bira"
#ZSH_THEME="ys"
#ZSH_THEME="xiong-chiamiov-plus"
#ZSH_THEME="jonathan"
#ZSH_THEME="avit"
#ZSH_THEME="robbyrussell"
#ZSH_THEME="powerlevel10k"

# Example aliases
alias remove="sudo apt-get remove"
alias install="sudo apt-fast install"
alias update="sudo apt-fast update"
alias upgrade="sudo apt-fast upgrade"
alias mysqlp="mysql -uroot -p123456"
alias ne="neofetch"
alias sfs="sudo freeswitch -nc -nonat"
alias sfs_testing="sudo freeswitch -nc -nonat -conf /usr/local/freeswitch/conf.testing -log /usr/local/freeswitch/log -db /usr/local/freeswitch/db"
alias svim="sudo vim"
alias sra="sudo ranger"
alias ra="ranger"
alias l='ls -CF'
alias mvSwap="~/.config/scripts/mvSwap.sh"
alias lg="lazygit"
alias jpconfig="cd ~/.config/nvim/"
alias ssh221="ssh root@192.168.100.221 -p5022"
alias edit_wt="vi /mnt/c/Users/waves/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
alias edit_wt_preview="vi /mnt/c/Users/waves/AppData/Local/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json"
alias mysql_4902x="mysql -upre -pODcgSwkfGtWUAuX9EKRh --host=10.172.58.25 --port=3401"
alias mysql_opensips="mysql -uggs -pQ6xn537jfwJDVUGNTLq4 --host=10.172.58.25 --port=3405"
alias gogo="cd ~/Workspace/golang/src/"
alias restartDocker="sudo ~/.config/scripts/auto_docker restart"
alias leetcode="NODE_NO_WARNINGS=1 leetcode"

# alias for themes and font types
alias theme_deus="cp ~/Backup/settings.json_dark /mnt/c/Users/waves/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json && cd ~/.config/nvim/ && git checkout master && cd -"
alias theme_space_light="cp ~/Backup/settings.json_light /mnt/c/Users/waves/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json && cd ~/.config/nvim/ && git checkout light_mode && cd -"
alias theme_gruvbox="cp ~/Backup/settings.json_gruvbox /mnt/c/Users/waves/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json && cd ~/.config/nvim/ && git checkout gruvbox && cd -"
alias theme_everforest="cp ~/Backup/settings.json_everforest /mnt/c/Users/waves/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json && cd ~/.config/nvim/ && git checkout forest_night && cd -"
alias theme_sonokai="cp ~/Backup/settings.json_sonokai /mnt/c/Users/waves/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json && cd ~/.config/nvim/ && git checkout sonokai && cd -"
alias theme_everforest_light="cp ~/Backup/settings.json_everlight /mnt/c/Users/waves/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json && cd ~/.config/nvim/ && git checkout everforest_light && cd -"
alias theme_aquarium="cp ~/Backup/settings.json_aquarium /mnt/c/Users/waves/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json && cd ~/.config/nvim/ && git checkout master && cd -"
# fonts change alias
alias font_lig_src_pro="sed -i 's/\"face\":.*/\"face\": \"LigaSrcPro NF\",/g' /mnt/c/Users/waves/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
alias font_recursive_unsimple="sed -i 's/\"face\":.*/\"face\": \"RecMonoGenmzyUnsimple NF\",/g' /mnt/c/Users/waves/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
alias font_consolig="sed -i 's/\"face\":.*/\"face\": \"Consolig NF\",/g' /mnt/c/Users/waves/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
alias font_consolas="sed -i 's/\"face\":.*/\"face\": \"Consolas NF\",/g' /mnt/c/Users/waves/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"

## For gnome settings
# alias caps_to_esc="/usr/bin/xmodmap -e 'clear lock' && /usr/bin/xmodmap -e 'keysym Caps_Lock = Escape'"
# alias getFlexibleKey="gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30 && gsettings set org.gnome.desktop.peripherals.keyboard delay 250"

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH

# install zplug, plugin manager for zsh, https://github.com/zplug/zplug
# curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
# zplug configruation
if [[ ! -d "${ZPLUG_HOME}" ]]; then
  if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
    # If we can't get zplug, it'll be a very sobering shell experience. To at
    # least complete the sourcing of this file, we'll define an always-false
    # returning zplug function.
    if [[ $? != 0 ]]; then
      function zplug() {
        return 1
      }
    fi
  fi
  export ZPLUG_HOME=~/.zplug
fi
if [[ -d "${ZPLUG_HOME}" ]]; then
  source "${ZPLUG_HOME}/init.zsh"
fi

zplug 'plugins/git', from:oh-my-zsh, if:'which git'
zplug 'romkatv/powerlevel10k', use:powerlevel10k.zsh-theme
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-completions', defer:2
zplug 'zsh-users/zsh-history-substring-search'
zplug 'zsh-users/zsh-syntax-highlighting', defer:2

if ! zplug check; then
  zplug install
fi

zplug load

# source your own shrc file if exists
[ -f ~/.env.sh ] && source ~/.env.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.config/p10k/p10k.zsh ]] && source ~/.config/p10k/p10k.zsh

# NOTE: use cc to clear screen. I use tmux ctrl+hjkl switch panel, but ctrl+l conflict with clear-screen
# bindkey "cc" clear-screen

#export JAVA_HOME=/opt/environment/java/jdk-13.0.2
#export JRE_HOME=/${JAVA_HOME}
#export CLASSPATH=.:${JAVA_HOME}/libss:${JRE_HOME}/lib
#export PATH=${JAVA_HOME}/bin:$PATH
##export CATALINA_HOME=/usr/local/apache-tomcat9
export JAVA_HOME=/opt/environment/java/jdk1.8
export CLASSPATH=.:${JAVA_HOME}/jre/lib/rt.jar:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar
export PATH=${JAVA_HOME}/bin:${PATH}

#fzf
export FZF_DEFAULT_OPTS='--bind ctrl-e:down,ctrl-u:up --tabstop=4 --preview "[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || (ccat --color=always {} || hlight -O ansi -l {} || cat {}) 2> /dev/null | head -8000"'
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore .github -g ""'
export FZF_COMPLETION_TRIGGER='\'
export FZF_TMUX_HEIGHT='80%'
export FZF_PREVIEW_COMMAND='[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || (ccat --color=always {} || cat {}) 2> /dev/null | head -8000'
source ~/.config/fzf/key-bindings.zsh
source ~/.config/fzf/completion.zsh

# github
export REPO_URL='https://mirrors.tuna.tsinghua.edu.cn/git/git-repo/'

export GOROOT=/opt/environment/go
export GOPATH=$HOME/Workspace/golang/
export GOBIN=$GOPATH/bin
export PATH=$GOPATH:$GOBIN:$GOROOT/bin:$PATH
export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct
export GOTRACEBACK=1
#export BAT_THEME="Nord"
export BAT_THEME="ansi-dark"

export https_proxy="http://192.168.50.88:15083"
export ALL_PROXY="socks5://192.168.50.88:15083"
export winhome=/mnt/c/Users/waves/
export windesk=/mnt/c/Users/waves/Desktop/
export windownload=/mnt/c/Users/waves/Downloads/
export winfonts=/mnt/d/font/

PATH="/home/waves/Workspace/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/waves/Workspace/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/waves/Workspace/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/waves/Workspace/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/waves/Workspace/perl5"; export PERL_MM_OPT;

alias luamake=/home/waves/Workspace/lua/ls/lua-language-server/3rd/luamake/luamake

export ERLANG_HOME=/opt/environment/erlang
export PATH=$PATH:${ERLANG_HOME}/bin
export PATH=$PATH:/usr/local/rabbitmq_server/sbin
export RABBITMQ_HOME=/usr/local/rabbitmq_server

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

/usr/bin/tabs 4
