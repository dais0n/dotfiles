# --------------
# general
# --------------
fpath=( "$HOME/.zfunctions" $fpath )

# include
ZSHHOME="${HOME}/.zsh.d"
if [ -d $ZSHHOME -a -r $ZSHHOME -a \
     -x $ZSHHOME ]; then
    for i in $ZSHHOME/*; do
        [[ ${i##*/} = *.zsh ]] &&
            [ \( -f $i -o -h $i \) -a -r $i ] && . $i
    done
fi

setopt nonomatch
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
# go 1.12
export GO111MODULE=on

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
alias ghd='cd $(ghq list --full-path | fzf)'
alias grep='grep --color'
alias ij='open -b com.jetbrains.intellij'
alias tsplit='tmux split-window -v -p 30 && tmux split-window -h -p 66 && tmux split-window -h -p 50 '

if [ "$(uname)" = 'Darwin' ]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi

if type "exa" > /dev/null 2>&1; then
    alias ls='exa --git'
    alias ll='exa -halT --git --time-style=iso --group-directories-first'
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
export TEXPATH="/Library/TeX/texbin"
if [ -e "${TEXPATH}" ]; then
    export PATH=${TEXPATH}/bin:$PATH
fi
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
# anyenv
eval "$(anyenv init - zsh)"
export PATH="$HOME/.anyenv/bin:$PATH"
# rust
export PATH="$HOME/.cargo/bin:$PATH"
# go
export GOENV_DISABLE_GOPATH=1
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# --------------
# func
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

function pet-select() {
  BUFFER=$(pet search --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N pet-select
stty -ixon
bindkey '^s' pet-select

function secenv()
{
    file=~/.secret_environment_value
    if [ $# -eq 0 ]; then
        `gpg <$file`
    fi
    if [ $# -eq 1 ]; then
        `gpg -c --output $file $1`
    fi
}

function prev-cmd-register-to-pet() {
  PREV=$(fc -lrn | head -n 1)
  sh -c "pet new `printf %q "$PREV"`"
}

function fzf-checkout-pull-request () {
    local selected_pr_id=$(gh pr list | fzf | awk '{ print $1 }')
    if [ -n "$selected_pr_id" ]; then
        BUFFER="gh pr checkout ${selected_pr_id}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N fzf-checkout-pull-request

# rf. https://blog.n-z.jp/blog/2014-07-25-compact-chpwd-recent-dirs.html
function my-compact-chpwd-recent-dirs () {
    emulate -L zsh
    setopt extendedglob
    local -aU reply
    integer history_size
    autoload -Uz chpwd_recent_filehandler
    chpwd_recent_filehandler
    history_size=$#reply
    reply=(${^reply}(N))
    (( $history_size == $#reply )) || chpwd_recent_filehandler $reply
}

# --------------
# plugins
# --------------
# zsh-syntax-highlighting
[ -f ${HOME}/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ${HOME}/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-autosuggestions
[ -f ${HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ${HOME}/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# prompt
eval "$(starship init zsh)"

