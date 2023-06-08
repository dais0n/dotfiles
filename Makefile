export
XDG_CONFIG_HOME := $(HOME)/.config

.PHONY: link
link:
	ln -sfv $(HOME)/dotfiles/.config/* $(XDG_CONFIG_HOME)
	ln -sfv .config/zsh/.zshenv $(HOME)/.zshenv

.PHONY: tmux-init
tmux-init: ## install tmux plugin manager
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
