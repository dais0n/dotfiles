UNAME 	          := $(shell uname)
CURRENTDIR        := $(shell pwd)
export
XDG_CONFIG_HOME := $(HOME)/.config
G_DATA_HOME := "$(HOME)/.local/share
XDG_STATE_HOME := $(HOME)/.local/state

.PHONY: link
link:
	ln -sfv $(HOME)/dotfiles/.config/* $(XDG_CONFIG_HOME)
	ln -sfv .config/zsh/.zshenv $(HOME)/.zshenv

.PHONY: vim-init
vim-init:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

.PHONY: nvim-init
nvim-init: ## install nvim
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	ln -snfv $(CURRENTDIR)/.config/nvim/init.vim $(HOME)/.config/nvim/init.vim

tmux-init: ## install tmux plugin manager
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

.PHONY: help
help: ## print all available commands
	@printf "\033[36m%-30s\033[0m %-50s %s\n" "[Sub command]" "[Description]" "[Example]"
	@grep -E '^[/a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | perl -pe 's%^([/a-zA-Z_-]+):.*?(##)%$$1 $$2%' | awk -F " *?## *?" '{printf "\033[36m%-30s\033[0m %-50s %s\n", $$1, $$2, $$3}'
