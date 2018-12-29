DOTFILES_EXCLUDES := .DS_Store .git .gitmodules .travis.yml .zsh .screenrc
DOTFILES_TARGET   := $(wildcard .??*)
CLEAN_TARGET      := $(wildcard .??*) .vim .zfunctions
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))
UNAME 	          := $(shell uname)
CURRENTDIR        := $(shell pwd)
IS_CTAGS          := $(shell ctags --version 2> /dev/null)

install: vim-init zsh-init
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	vim +PlugInstall +qall
	zsh
vim-init: ctags-init
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
emacs-init:
	ln -snfv $(CURRENTDIR)/.emacs.d/init.el $(HOME)/.emacs.d/init.el
zsh-init: peco-init pure-init
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
	git clone -b v0.4.0 https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
	ln -snfv $(CURRENTDIR)/.zsh/snippets $(HOME)/.zsh/snippets
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
	mkdir ~/.zfunctions
	curl -L https://raw.githubusercontent.com/dais0n/pure/master/pure.zsh > ~/.zfunctions/prompt_pure_setup
	curl -L https://raw.githubusercontent.com/dais0n/pure/master/async.zsh > ~/.zfunctions/async
ctags-init:
ifdef IS_CTAGS
	@echo "ctags installed"
else
	curl -LO 'http://prdownloads.sourceforge.net/ctags/ctags-5.8.tar.gz'
	tar -zxvf ctags-5.8.tar.gz
	cd ctags-5.8 && ./configure --prefix=/usr/local && make && sudo make install
	rm -rf ctags-5.8 && rm ctags-5.8.tar.gz
endif
ghq-init:
ifeq ($(UNAME),Darwin)
	wget https://github.com/motemen/ghq/releases/download/v0.7.4/ghq_darwin_amd64.zip
	unzip ghq_darwin_amd64.zip && sudo mv ghq /usr/local/bin && rm -rf ghq_darwin_amd64* zsh README.txt
endif
ifeq ($(UNAME),Linux)
	wget https://github.com/motemen/ghq/releases/download/v0.7.4/ghq_linux_amd64.zip
	unzip ghq_linux_amd64.zip -d ghq_linux_amd64 && sudo mv ghq_linux_amd64/ghq /usr/local/bin && rm -rf ghq_linux_amd64*
endif
ag-init:
	wget https://geoff.greer.fm/ag/releases/the_silver_searcher-2.1.0.tar.gz
	tar -zxvf the_silver_searcher-2.1.0.tar.gz
	cd the_silver_searcher-2.1.0 && ./configure --prefix=/usr/local && make && sudo make install
php-init:
	curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && composer
	composer global require "squizlabs/php_codesniffer=*"
	composer global require "phpmd/phpmd"
docker-init:
	curl -fLo ~/.zfunctions/_docker https://raw.github.com/felixr/docker-zsh-completion/master/_docker
	exec zsh
nvim-init:
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	ln -snfv $(CURRENTDIR)/.config/nvim/init.vim $(HOME)/.config/nvim/init.vim
clean:
	@$(foreach val, $(CLEAN_TARGET), rm -rf $(HOME)/$(val);)
update:
	vim +PlugInstall +qall
	zsh
