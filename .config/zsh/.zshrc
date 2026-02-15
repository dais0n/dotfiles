bindkey -e

# prompt
setopt PROMPT_SUBST
PS1='%F{green}%n@%m:%F{cyan}%~$(parse_git_branch)
$ '
parse_git_branch() {
  local branch=$(git branch --show-current 2>/dev/null)
  [[ -n $branch ]] && echo " ($branch)"
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
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export WORDCHARS="*?_.[]~-=&;!#$%^(){}<>\'"
export AWS_PROFILE=saml
export LS_COLORS="di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32"
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
for f in ~/.zsh.d/*.zsh(N); do source "$f"; done
export EDITOR='nvim'
AUTH_SOCK="$HOME/.ssh/.ssh-auth-sock"
if [ -S "$AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK=$AUTH_SOCK
elif [ ! -S "$SSH_AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK=$AUTH_SOCK
elif [ ! -L "$SSH_AUTH_SOCK" ]; then
    ln -snf "$SSH_AUTH_SOCK" $AUTH_SOCK && export SSH_AUTH_SOCK=$AUTH_SOCK
fi
export VISUAL='nvim'

# history
export HISTFILE="${XDG_STATE_HOME}/zsh/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt GLOBDOTS
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt INTERACTIVE_COMMENTS
setopt SHARE_HISTORY
setopt MAGIC_EQUAL_SUBST
setopt PRINT_EIGHT_BIT
setopt noflowcontrol
setopt HIST_VERIFY

zstyle ':chpwd:*' recent-dirs-max 200
zstyle ':chpwd:*' recent-dirs-default yes

# ref: https://gist.github.com/danydev/4ca4f5c523b19b17e9053dfa9feb246d
autoload -Uz chpwd_recent_dirs cdr
autoload -U add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
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
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word

function texc() {
  platex "$1" && platex "$1" && dvipdfmx "${1%.tex}.dvi" && rm -f ${1%.tex}.{aux,log,dvi}
}

# alias
alias k='kubectl'
alias g='git'
alias ls='ls --color=auto'
alias ghd='cd $(ghq list --full-path | fzf)'
alias clip.exe='iconv -t sjis | clip.exe'
alias pbcopy='clip.exe'
(( ${+commands[nvim]} )) && alias vi='nvim'

function fzf-cdr() {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | fzf --reverse)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N fzf-cdr
bindkey '^q' fzf-cdr

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

autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

if type direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

if type mise &>/dev/null; then
  eval "$(mise activate zsh)"
  eval "$(mise activate --shims)"
fi

# Claude Code prompt editing with tmux popup
claude-prompt-edit() {
  local target_pane="$1"
  local tmpfile=$(mktemp /tmp/claude-prompt-XXXXX.claude)
  nvim -c "startinsert" "$tmpfile"
  if [ -s "$tmpfile" ]; then
    tmux load-buffer "$tmpfile"
    tmux paste-buffer -p -t "$target_pane"
  fi
  rm -f "$tmpfile"
}
