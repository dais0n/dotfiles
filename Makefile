DOTFILES_EXCLUDES := .DS_Store .git .gitmodules .travis.yml .zsh .screenrc
DOTFILES_TARGET   := $(wildcard .??*)
CLEAN_TARGET      := $(wildcard .??*) .vim .zfunctions
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))
UNAME 	          := $(shell uname)
CURRENTDIR        := $(shell pwd)
IS_CTAGS          := $(shell ctags --version 2> /dev/null)

.PHONY: help
## print all available commands
help:
	@awk '/^[a-zA-Z\_0-9%:\\\/-]+:/ { \
	  helpMessage = match(lastLine, /^## (.*)/); \
	  if (helpMessage) { \
	    helpCommand = $$1; \
	    helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
      gsub("\\\\", "", helpCommand); \
      gsub(":+$$", "", helpCommand); \
	    printf "  \x1b[32;01m%-35s\x1b[0m %s\n", helpCommand, helpMessage; \
	  } \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST) | sort -u
	@printf "\n"

.PHONY: install
## zsh and vim init and make symlink
install: vim-init zsh-init
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	vim +PlugInstall +qall
	zsh

.PHONY: vim-init
## install vim-plug
vim-init:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

.PHONY: zsh-init
## install prompt theme and fzf
zsh-init: fzf-init pure-init
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
	git clone -b v0.4.0 https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
	ln -snfv $(CURRENTDIR)/.zsh/snippets $(HOME)/.zsh/snippets

.PHONY: fzf-init
## install fzf

.PHONY: pure-init
## install pure prompt
pure-init:
	mkdir ~/.zfunctions
	curl -L https://raw.githubusercontent.com/dais0n/pure/master/pure.zsh > ~/.zfunctions/prompt_pure_setup
	curl -L https://raw.githubusercontent.com/dais0n/pure/master/async.zsh > ~/.zfunctions/async

.PHONY: ghq-init
## install ghq
ghq-init:
ifeq ($(UNAME),Darwin)
	wget https://github.com/motemen/ghq/releases/download/v0.7.4/ghq_darwin_amd64.zip
	unzip ghq_darwin_amd64.zip && sudo mv ghq /usr/local/bin && rm -rf ghq_darwin_amd64* zsh README.txt
endif
ifeq ($(UNAME),Linux)
	wget https://github.com/motemen/ghq/releases/download/v0.7.4/ghq_linux_amd64.zip
	unzip ghq_linux_amd64.zip -d ghq_linux_amd64 && sudo mv ghq_linux_amd64/ghq /usr/local/bin && rm -rf ghq_linux_amd64*
endif

.PHONY: docker-init
## install docker completion
docker-init:
	curl -fLo ~/.zfunctions/_docker https://raw.github.com/felixr/docker-zsh-completion/master/_docker
	exec zsh

.PHONY: kubectx-init
## install kubectx completion
kubectx-init:
	curl -fLo ~/.zfunctions/_kubectx https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/kubectx.zsh
	curl -fLo ~/.zfunctions/_kubens https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/kubens.zsh

.PHONY: nvim-init
## install nvim
nvim-init:
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	ln -snfv $(CURRENTDIR)/.config/nvim/init.vim $(HOME)/.config/nvim/init.vim

.PHONY: krew-init
## install krew
krew-init:
	set -x; cd "$(mktemp -d)" &&
	curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v0.3.3/krew.{tar.gz,yaml}" &&
	tar zxvf krew.tar.gz &&
	KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" &&
	"$KREW" install --manifest=krew.yaml --archive=krew.tar.gz &&
	"$KREW" update

.PHONY: clean
## unlink symlink and delete dotfiles
clean:
	@$(foreach val, $(CLEAN_TARGET), rm -rf $(HOME)/$(val);)
