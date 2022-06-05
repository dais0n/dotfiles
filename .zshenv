### locale ###
export LANG="en_US.UTF-8"

### XDG ###
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

### zsh ###
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

### Go ###
export GOPATH="$XDG_DATA_HOME/go"
export GO111MODULE="on"

### Delimitor ###
export WORDCHARS="*?_.[]~-=&;!#$%^(){}<>\'"

### Editor ###
export EDITOR="vi"
export GIT_EDITOR="$EDITOR"

### AWS ###
export AWS_PROFILE=saml

export LS_COLORS="di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32"