# --------------
# general
# --------------
fpath=( "$HOME/.zfunctions" $fpath )
export LANG='ja_JP.UTF-8'
export LC_ALL='ja_JP.UTF-8'
bindkey -e
DIRSTACKSIZE=100
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt noautoremoveslash
setopt nolistbeep
setopt auto_resume
setopt interactive_comments
setopt globdots # dotfile effective
setopt no_flow_control
bindkey "^[u" undo
bindkey "^[r" redo
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
export WORDCHARS="*?_.[]~-=&;!#$%^(){}<>\'" # delimitor
export LESS='-gj10 --no-init --quit-if-one-screen --RAW-CONTROL-CHARS -iMRN'

zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-pushd true

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
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

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
# alias
# --------------
alias e='emacs -nw'
alias k='kubectl'
alias l='ls -la'
alias h='hostname'
alias g='git'
alias u='cd ..'
alias du='du -h'
alias df='df -h'
alias kc='kubectx'
alias kn='kubens'
alias ls='ls -F'
alias ll='ls -ltr'
#alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
if which nvim >/dev/null 2>&1; then
    alias vi='nvim'
else
    alias vi='vim'
fi
alias rmi='rm -i'
alias ghd='cd $(ghq list --full-path | fzf)'
alias grep='grep --color'
alias vg='agvim'
alias ij='open -b com.jetbrains.intellij'
alias tsplit='tmux split-window -v -p 30 && tmux split-window -h -p 66 && tmux split-window -h -p 50 '

if [ "$(uname)" = 'Darwin' ]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi

if type "exa" > /dev/null 2>&1; then
    alias ls='exa --git'
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
export GOENVPATH="${HOME}/.goenv"
if [ -e "${GOENVPATH}" ]; then
    export PATH=${GOENVPATH}/bin:$PATH
    eval "$(goenv init -)"
fi
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_192.jdk/Contents/Home
if [ -e "${JAVA_HOME}" ]; then
    export PATH=$PATH:$JAVA_HOME/bin
fi
export PHP_HOME="${HOME}/.composer/vendor"
if [ -e "${PHP_HOME}" ]; then
    export PATH=$PATH:$PHP_HOME/bin
fi
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# go 1.12
export GO111MODULE=on

# --------------
# fzf
# --------------
function fzf-history() {
  BUFFER=$(history -n -r 1 | fzf -e --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
  zle reset-prompt
}

zle -N fzf-history
bindkey '^R' fzf-history

function fzf-cdr() {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | fzf -e --prompt="Cdr > ")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}
zle -N fzf-cdr
bindkey '^Z' fzf-cdr

function fzf-snippets() {
    BUFFER=$(grep -v "^#" ~/.zsh/snippets | fzf -e --query "$LBUFFER" --prompt="Snippet > ")
    zle reset-prompt
}
zle -N fzf-snippets
bindkey '^S' fzf-snippets

# --------------
# plugins
# --------------
# zsh-syntax-highlighting
[ -f ${HOME}/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ${HOME}/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-autosuggestions
[ -f ${HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ${HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# prompt
eval "$(starship init zsh)"
