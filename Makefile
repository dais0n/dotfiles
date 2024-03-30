export
XDG_CONFIG_HOME := $(HOME)/.config

.PHONY: link
link:
	ln -s .gitconfig $(HOME)/.gitconfig
	ln -s .gitignore $(HOME)/.gitignore
	ln -sfv .config/zsh/.zshrc $(HOME)/.zshrc
	ln -sfv $(HOME)/dotfiles/.config/* $(XDG_CONFIG_HOME)

.PHONY: tmux-plugin-install
tmux-plugin-install:
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

.PHONY: sheldon-install
sheldon-install:
	curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
    | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin

.PHONY: fzf-install
fzf-install:
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
