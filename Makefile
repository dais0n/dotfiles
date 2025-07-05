DOTFILES_DIR    := $(CURDIR)
XDG_CONFIG_HOME := $(HOME)/.config
BIN_DIR         := $(HOME)/.local/bin
SHARE_DIR       := $(HOME)/.local/share

.PHONY: all
all: link

.PHONY: link
link: | mkdir
	ln -sfnv $(DOTFILES_DIR)/.gitconfig         $(HOME)/.gitconfig
	ln -sfnv $(DOTFILES_DIR)/.gitignore         $(HOME)/.gitignore
	ln -sfnv $(DOTFILES_DIR)/.config/zsh/.zshrc $(HOME)/.zshrc
	ln -sfnv $(DOTFILES_DIR)/.config/*          $(XDG_CONFIG_HOME)/

.PHONY: mkdir
mkdir:
	mkdir -p $(BIN_DIR) $(SHARE_DIR) $(XDG_CONFIG_HOME)

.PHONY: tmux-plugin-install
tmux-plugin-install:
	git clone --depth 1 https://github.com/tmux-plugins/tpm $(HOME)/.tmux/plugins/tpm

.PHONY: sheldon-install
sheldon-install:
	curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
	    | bash -s -- --repo rossmacarthur/sheldon --to $(BIN_DIR)

.PHONY: fzf-install
fzf-install:
	VERSION=$$(curl -s https://api.github.com/repos/junegunn/fzf/releases/latest \
		| grep '"tag_name":' | sed -E 's/.*"v?([^"]+)".*/\1/'); \
	curl -LO https://github.com/junegunn/fzf/releases/download/$$VERSION/fzf-$$VERSION-linux_amd64.tar.gz && \
	tar xvf fzf-$$VERSION-linux_amd64.tar.gz && \
	mv fzf $(BIN_DIR) && \
	rm fzf-$$VERSION-linux_amd64.tar.gz

.PHONY: nvim-install
nvim-install:
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && \
	tar xzf nvim-linux-x86_64.tar.gz --strip-components 1 -C $(HOME)/.local && \
	rm nvim-linux-x86_64.tar.gz

.PHONY: direnv-install
direnv-install:
	curl -sfL https://direnv.net/install.sh | bash
