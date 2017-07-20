DOTFILES_EXCLUDES := .DS_Store .git .gitmodules .travis.yml
DOTFILES_TARGET   := $(wildcard .??*) .vim .zsh .zfunctions
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))
UNAME 	          := ${shell uname}

install: vim-init zsh-init
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	vim +PlugInstall +qall
	zsh
vim-init: ctags-init
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
zsh-init: peco-init pure-init
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
peco-init:
ifeq ($(UNAME),Darwin)
	curl -L -O https://github.com/peco/peco/releases/download/v0.5.1/peco_darwin_amd64.zip
	unzip peco_darwin_amd64.zip && sudo mv peco_darwin_amd64/peco /usr/local/bin && rm -rf peco_darwin_amd64 peco_darwin_amd64.zip
endif
ifeq ($(UNAME),Linux)
	curl -L -O https://github.com/peco/peco/releases/download/v0.5.1/peco_linux_amd64.tar.gz
	tar -zxvf peco_linux_amd64.tar.gz && sudo mv peco_linux_amd64/peco /usr/local/bin && rm -rf peco_linux_amd64 peco_linux_amd64.tar.gz
endif
pure-init:
	mkdir $(HOME)/.zfunctions
	curl -L https://raw.githubusercontent.com/sindresorhus/pure/master/pure.zsh > $(HOME)/.zfunctions/prompt_pure_setup
	curl -L https://raw.githubusercontent.com/sindresorhus/pure/master/async.zsh > $(HOME)/.zfunctions/async
ctags-init:
	curl -LO http://prdownloads.sourceforge.net/ctags/ctags-5.8.tar.gz
	tar -zxvf ctags-5.6.tar.gz
	cd ctags-5.6 && ./configure --prefix=/usr/local &&  make && sudo make install
clean:
	@$(foreach val, $(DOTFILES_FILES), rm -rf $(HOME)/$(val);)
