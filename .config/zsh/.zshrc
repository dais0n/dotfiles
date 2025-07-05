bindkey -e

# prompt
setopt PROMPT_SUBST
PS1='%F{green}%n@%m:%F{cyan}%~$(parse_git_branch)
$ '
parse_git_branch() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# path
typeset -U path
path=(
    "/usr/local/bin"(N-/)
    "$HOME/.local/bin"(N-/)
    "$HOME/go/bin"(N-/)
    "$path[@]"
)

# env
export LANG='ja_JP.UTF-8'
export LC_ALL='ja_JP.UTF-8'
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export WORDCHARS="*?_.[]~-=&;!#$%^(){}<>\'"
export AWS_PROFILE=saml
export LS_COLORS="di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32"
export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/asdfrc"
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
# load variable by environment
ZSHHOME="${HOME}/.zsh.d"
if [ -d $ZSHHOME -a -r $ZSHHOME -a \
     -x $ZSHHOME ]; then
    for i in $ZSHHOME/*; do
        [[ ${i##*/} = *.zsh ]] &&
            [ \( -f $i -o -h $i \) -a -r $i ] && . $i
    done
fi
export EDITOR='vi'
# See http://mokokko.hatenablog.com/entry/2013/03/14/133850
AUTH_SOCK="$HOME/.ssh/.ssh-auth-sock"
if [ -S "$AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK=$AUTH_SOCK
elif [ ! -S "$SSH_AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK=$AUTH_SOCK
elif [ ! -L "$SSH_AUTH_SOCK" ]; then
    ln -snf "$SSH_AUTH_SOCK" $AUTH_SOCK && export SSH_AUTH_SOCK=$AUTH_SOCK
fi

# history
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


# ref: https://gist.github.com/danydev/4ca4f5c523b19b17e9053dfa9feb246d
autoload -U add-zsh-hook
function my_zshaddhistory() {
  LASTHIST=$1
  return 2
}
function save_last_command_in_history_if_successful() {
  # Write the last command if successful (or closed with signal 2), using
  # the history buffered by my_zshaddhistory().
  if [[ ($? == 0 || $? == 130) && -n $LASTHIST && -n $HISTFILE ]] ; then
    local cmd=${LASTHIST%%$'\n'}
    if [[ -n $cmd && $cmd != (ls|vi|cd)* ]]; then
      print -sr -- $cmd
    fi
  fi
}

add-zsh-hook precmd save_last_command_in_history_if_successful
add-zsh-hook zshexit save_last_command_in_history_if_successful
add-zsh-hook zshaddhistory my_zshaddhistory

widget::history() {
    local selected="$(history -inr 1 | fzf --exit-0 --query "$LBUFFER" | cut -d' ' -f4- | sed 's/\\n/\n/g')"
    if [ -n "$selected" ]; then
        BUFFER="$selected"
        CURSOR=$#BUFFER
    fi
    zle reset-prompt
}

zle -N widget::history
bindkey "^R" widget::history

# alias
alias k='kubectl'
alias g='git'
alias ls='ls --color=auto'
alias ghd='cd $(ghq list --full-path | fzf)'
alias clip.exe='iconv -t sjis | clip.exe'
alias pbcopy='clip.exe'
(( ${+commands[nvim]} )) && alias vi='nvim'

# plugin load by sheldon
sheldon::load() {
  local plugins_file="$XDG_CONFIG_HOME/sheldon/plugins.toml"
  local cache_file="$XDG_CACHE_HOME/sheldon/plugins.zsh"
  # If the compile cache (plugins.zsh) does not exist,
  # or its mtime is older than plugins.toml, store the output in the cache.
  # If plugin installation fails, just delete the cache_file.
  if [[ ! -f "$cache_file" || "$plugins_file" -nt "$cache_file" ]]; then
    mkdir -p "$XDG_CACHE_HOME/sheldon"
    sheldon source >"$cache_file"
    zcompile "$cache_file"
  fi
  builtin source "$cache_file"
}
sheldon::load

if type direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

if type mise &>/dev/null; then
  eval "$(mise activate zsh)"
  eval "$(mise activate --shims)"
fi
