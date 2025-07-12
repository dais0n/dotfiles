DOTFILES_DIR    := $(CURDIR)
XDG_CONFIG_HOME := $(HOME)/.config
BIN_DIR         := $(HOME)/.local/bin
SHARE_DIR       := $(HOME)/.local/share
STATE_DIR       := $(HOME)/.local/state

.PHONY: all
all: link

.PHONY: mise-install
mise-install:
	@command -v mise >/dev/null 2>&1 || { \
		echo "▶ Installing mise ..."; \
		curl https://mise.run | sh; \
		echo "✔ mise installed"; \
	} || echo "✔ mise already present"

.PHONY: tools
tools: mise-install
	@echo "▶ Installing tools via mise ..."
	@mise install
	@echo "✔ All tools installed"

.PHONY: link
link: tools | mkdir
	@echo "▶ Linking dotfiles ..."
	@ln -sfnv $(DOTFILES_DIR)/.gitconfig         $(HOME)/.gitconfig
	@ln -sfnv $(DOTFILES_DIR)/.gitignore         $(HOME)/.gitignore
	@ln -sfnv $(DOTFILES_DIR)/.config/zsh/.zshrc $(HOME)/.zshrc
	@ln -sfnv $(DOTFILES_DIR)/.config/*          $(XDG_CONFIG_HOME)/
	@echo "✔ Dotfiles linked"

.PHONY: mkdir
mkdir:
	@echo "▶ Creating directories ..."
	@mkdir -p $(BIN_DIR) $(SHARE_DIR) $(STATE_DIR) $(XDG_CONFIG_HOME)
	@echo "✔ Directories ready"
