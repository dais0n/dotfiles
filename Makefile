DOTFILES_DIR    := $(CURDIR)
XDG_CONFIG_HOME := $(HOME)/.config
BIN_DIR         := $(HOME)/.local/bin

.PHONY: all
all: link tools

.PHONY: tools
tools:
	mise install

.PHONY: link
link: | mkdir
	ln -sfnv $(DOTFILES_DIR)/.gitconfig         $(HOME)/.gitconfig
	ln -sfnv $(DOTFILES_DIR)/.gitignore         $(HOME)/.gitignore
	ln -sfnv $(DOTFILES_DIR)/.config/zsh/.zshrc $(HOME)/.zshrc
	ln -sfnv $(DOTFILES_DIR)/.config/*          $(XDG_CONFIG_HOME)/

.PHONY: mkdir
mkdir:
	mkdir -p $(BIN_DIR) $(HOME)/.local/share $(XDG_CONFIG_HOME)
