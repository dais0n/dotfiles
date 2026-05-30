bindkey -e

# path
typeset -U path
path=(
    "/usr/local/bin"(N-/)
    "/usr/local/go/bin"(N-/)
    "$HOME/.local/bin"(N-/)
    "$HOME/go/bin"(N-/)
    "$HOME/.cargo/bin"(N-/)
    "$path[@]"
)

# env
export LANG='ja_JP.UTF-8'
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export WORDCHARS="*?_.[]~-=&;!#$%^(){}<>\'"
# AWS_PROFILE はリポジトリの .envrc で指定する
export LS_COLORS="di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32"
# 拡張子別の色
LS_COLORS+=":*.7z=01;31:*.arj=01;31:*.bz2=01;31:*.cpio=01;31:*.deb=01;31:*.gz=01;31:*.jar=01;31:*.lz=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.rar=01;31:*.rpm=01;31:*.tar=01;31:*.taz=01;31:*.tbz=01;31:*.tgz=01;31:*.txz=01;31:*.tz=01;31:*.war=01;31:*.xz=01;31:*.z=01;31:*.zip=01;31:*.zst=01;31"
LS_COLORS+=":*.avif=01;35:*.bmp=01;35:*.gif=01;35:*.heic=01;35:*.ico=01;35:*.jpeg=01;35:*.jpg=01;35:*.png=01;35:*.svg=01;35:*.tif=01;35:*.tiff=01;35:*.webp=01;35:*.avi=01;35:*.flv=01;35:*.m4v=01;35:*.mkv=01;35:*.mov=01;35:*.mp4=01;35:*.mpeg=01;35:*.mpg=01;35:*.webm=01;35:*.wmv=01;35"
LS_COLORS+=":*.aac=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.mka=00;36:*.mp3=00;36:*.oga=00;36:*.ogg=00;36:*.opus=00;36:*.ra=00;36:*.wav=00;36"
export LS_COLORS
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
for f in ~/.zsh.d/*.zsh(N); do source "$f"; done
export EDITOR='nvim'
export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt
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
setopt MAGIC_EQUAL_SUBST
setopt PRINT_EIGHT_BIT
setopt NO_FLOW_CONTROL
setopt HIST_VERIFY

zstyle ':chpwd:*' recent-dirs-max 200
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

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
if [[ -n ${XDG_CACHE_HOME}/zsh/zcompdump(#qN.mh+24) ]]; then
  compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump"
else
  compinit -C -d "${XDG_CACHE_HOME}/zsh/zcompdump"
fi

if (( ${+commands[direnv]} )); then
  eval "$(direnv hook zsh)"
fi

if (( ${+commands[mise]} )); then
  eval "$(mise activate zsh --shims)"
fi

# prompt
PURE_PROMPT_SYMBOL='$'
PURE_CMD_MAX_EXEC_TIME=3
PURE_GIT_UNTRACKED_DIRTY=0
PURE_GIT_PULL=0
zstyle ':prompt:pure:git:stash' show yes
autoload -U promptinit && promptinit
prompt pure

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
