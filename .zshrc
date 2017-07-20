# --------------
# general
# --------------
export LANG='ja_JP.UTF-8'
export LC_ALL='ja_JP.UTF-8'
bindkey -e
DIRSTACKSIZE=100
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt noautoremoveslash
setopt nolistbeep
setopt globdots # dotfile effective
bindkey "^[u" undo
bindkey "^[r" redo
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# --------------
# prompt
# --------------
autoload -U promptinit; promptinit
prompt pure

# --------------
# completion
# --------------
zmodload zsh/complist
autoload -Uz compinit && compinit
setopt list_packed
# sudo
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
    /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# --------------
# history
# --------------
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt extended_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_expire_dups_first
setopt hist_expand
setopt inc_append_history
autoload history-search-end

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end # CTRL-P
bindkey "^N" history-beginning-search-forward-end # CTRL-N
bindkey "\\ep" history-beginning-search-backward-end # ESC-P
bindkey "\\en" history-beginning-search-forward-end # ESC-N

# --------------
# ssh
# --------------
# .ssh  for .ssh/ssh-configs/*/config
alias ssh='cat ~/.ssh/ssh-configs/_config.global ~/.ssh/ssh-configs/*/config > ~/.ssh/config; ssh'
#chmod 700 ~/.ssh/config

# --------------
# alias
# --------------
alias du='du -h'
alias df='df -h'
alias ll='ls -lath'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias g='git'
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias vi='vim'
alias rmi='rm -i'
alias ghd='cd $(ghq list --full-path | peco)'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git log --graph --decorate --oneline'
alias gs='git status'
alias gp='git pull --rebase'
if [ "$(uname)" = 'Darwin' ]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi

function extract() {
  case $1 in
    *.tar.gz|*.tgz) tar xzvf $1;;
    *.tar.xz) tar Jxvf $1;;
    *.zip) unzip $1;;
    *.lzh) lha e $1;;
    *.tar.bz2|*.tbz) tar xjvf $1;;
    *.tar.Z) tar zxvf $1;;
    *.gz) gzip -d $1;;
    *.bz2) bzip2 -dc $1;;
    *.Z) uncompress $1;;
    *.tar) tar xvf $1;;
    *.arj) unarj $1;;
  esac
}
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract

# --------------
# path
# --------------
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
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
export GOPATH="${HOME}/go"
if [ -e "${GOPATH}" ]; then
    export PATH=${GOPATH}/bin:$PATH
fi

# --------------
# peco
# --------------
function peco-select-history {
    BUFFER=`history -n -r 1 | peco --query "$LBUFFER"`
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-select-history
bindkey '^r' peco-select-history

function peco-cd () {
    local selected_dir=$(find ~/ -type d | peco)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-cd
bindkey '^x^f' peco-cd

function peco-cdr() {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-cdr
bindkey '^Z' peco-cdr

# --------------
# plugin
# --------------
# zsh-syntax-highlighting
[ -f ${HOME}/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ${HOME}/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f ${HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ${HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

