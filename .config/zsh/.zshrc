### general
bindkey -e

# include my zsh file
ZSHHOME="${HOME}/.zsh.d"
if [ -d $ZSHHOME -a -r $ZSHHOME -a \
     -x $ZSHHOME ]; then
    for i in $ZSHHOME/*; do
        [[ ${i##*/} = *.zsh ]] &&
            [ \( -f $i -o -h $i \) -a -r $i ] && . $i
    done
fi

### path
typeset -U path
path=(
    "$HOME/.local/bin"(N-/)
    "$GOPATH/bin"(N-/)
    "$path[@]"
)

fpath+="$XDG_DATA_HOME/zsh/typewritten"

### prompt
setopt PROMPT_SUBST
PS1='%F{green}%n@%m:%F{cyan}%~$(parse_git_branch)
$ '
parse_git_branch() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# To enable agent forwarding when screen is reconnected.
# See http://mokokko.hatenablog.com/entry/2013/03/14/133850
AUTH_SOCK="$HOME/.ssh/.ssh-auth-sock"
if [ -S "$AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK=$AUTH_SOCK
elif [ ! -S "$SSH_AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK=$AUTH_SOCK
elif [ ! -L "$SSH_AUTH_SOCK" ]; then
    ln -snf "$SSH_AUTH_SOCK" $AUTH_SOCK && export SSH_AUTH_SOCK=$AUTH_SOCK
fi

### history
export HISTFILE="${XDG_STATE_HOME}/zsh/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt GLOBDOTS
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt INTERACTIVE_COMMENTS
setopt SHARE_HISTORY
setopt MAGIC_EQUAL_SUBST
setopt PRINT_EIGHT_BIT

zshaddhistory() {
    local line="${1%%$'\n'}"
    [[ ! "$line" =~ "^(cd|ls|rm|kill)($| )" ]]
}

widget::history() {
    local selected="$(history -inr 1 | fzf --exit-0 --query "$LBUFFER" | cut -d' ' -f4- | sed 's/\\n/\n/g')"
    if [ -n "$selected" ]; then
        BUFFER="$selected"
        CURSOR=$#BUFFER
    fi
    zle reset-prompt
}

zle -N widget::history
bindkey "^R"  widget::history

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### lazy load ###
zinit wait lucid light-mode as'null' \
    atinit'source "$ZDOTDIR/.zshrc.lazy"' \
    for 'zdharma-continuum/null'
