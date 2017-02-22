# --------------
# general
# --------------
#locale
export LANG='ja_JP.UTF-8'
export LC_ALL='ja_JP.UTF-8'
#prompt
autoload -U promptinit
autoload -U colors && colors
# vcs
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
_vcs_precmd () { vcs_info }
autoload -Uz add-zsh-hook
add-zsh-hook precmd _vcs_precmd 
# prompt colors(black, red, green, yellow, blue, magenda, cyan, white)
PROMPT='%{${fg[yellow]}%}%~%{${reset_color}%}
%{${fg[green]}%}[%m@%n]%{${reset_color}%}%{${fg[blue]}%}$vcs_info_msg_0_%{${reset_color}%}$ '
# path
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# less env
export LESS='-i -M -R'
# cdr
setopt pushd_ignore_dups
setopt AUTO_PUSHD
DIRSTACKSIZE=100
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
# emacs keybind
bindkey -e
# autocd
setopt auto_cd

# --------------
# plugin
# --------------
if [ ! -e "${HOME}/.zplug/init.zsh" ]; then
  curl -sL zplug.sh/installer | zsh
fi
source ${HOME}/.zplug/init.zsh
# install plugins
zplug 'zsh-users/zsh-completions'
zplug 'zsh-users/zsh-syntax-highlighting'
zplug 'felixr/docker-zsh-completion'
zplug 'zsh-users/zsh-autosuggestions'
zplug "mollifier/anyframe"
# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load --verbose
# plugin settings
export FZF_DEFAULT_COMMAND='ag -g ""'
bindkey '^Z' anyframe-widget-cdr
bindkey '^R' anyframe-widget-put-history
# --------------
# completion
# --------------
autoload -Uz compinit && compinit
# sudo
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
    /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
# docker
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# --------------
# history
# --------------
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_expand
setopt inc_append_history

# --------------
# ssh
# --------------
# .ssh  for .ssh/ssh-configs/*/config
alias ssh='cat ~/.ssh/ssh-configs/_config.global ~/.ssh/ssh-configs/*/config > ~/.ssh/config; ssh'
#chmod 700 ~/.ssh/config

# --------------
# alias
# --------------
alias ls='ls -G'
alias ll='ls -lah'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias sudo='sudo '
alias vi='vim'
alias rmi='rm -i' 
# ▼ global alias

alias -g G='| grep'
alias -g L='| less'

if which pbcopy >/dev/null 2>&1 ; then 
    # Mac  
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then 
    # Linux
    alias -g C='| xsel --input --clipboard'
fi

alias gd='cd $GOPATH/src/github.com/daison8383'

# --------------
# other
# --------------
export PYENV_ROOT="${HOME}/.pyenv"
if [ -d "${PYENV_ROOT}" ]; then
    export PATH=${PYENV_ROOT}/bin:$PATH
    eval "$(pyenv init -)"
fi
export TEXPATH="/Library/TeX/texbin"
if [ -e "${TEXPATH}" ]; then
    export PATH=${TEXPATH}/bin:$PATH
fi
export NODE_BREW_DIR="${HOME}/.nodebrew/current/bin"
if [ -e "${NODE_BREW_DIR}" ]; then
    export PATH=${NODE_BREW_DIR}:$PATH
fi
# go path
export GOPATH="${HOME}/go"
if [ -e "${GOPATH}" ]; then
    export PATH=${GOPATH}/bin:$PATH
fi
