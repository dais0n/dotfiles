"----------------
" init
"----------------
" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

"----------------
" statusline
"----------------
"set statusline=%F  " filename
"set statusline+=%m " check mode change
"set statusline+=%r " check readonly
"set statusline+=%h " help page
"set statusline+=%w " preview
" rightstatus
"set statusline+=%=
"set statusline+=[ENC=%{&fileencoding}] " file encoding
"set statusline+=[LOW=%l/%L] " display rows
"function! g:Date()
"    return strftime("%x %H:%M")
"endfunction
"set statusline+=\ \%{g:Date()}
set laststatus=2  " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set completeopt=menuone
set encoding=UTF-8

"-----------------
" plugin
"-----------------
call plug#begin('~/.vim/plugged')
" general
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jnurmine/Zenburn'
Plug 'tpope/vim-surround'
Plug 'scrooloose/syntastic'
Plug 'tomtom/tcomment_vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'majutsushi/tagbar'
Plug 'jiangmiao/auto-pairs'
Plug 'glidenote/memolist.vim'
Plug 'tyru/open-browser.vim'
Plug 'kannokanno/previm'
Plug 'thinca/vim-quickrun'
Plug 'ntpeters/vim-better-whitespace'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'szw/vim-tags'
Plug 'ervandew/supertab'
Plug 'vim-airline/vim-airline'
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
" nerdtree
Plug 'scrooloose/nerdtree'
" php support
Plug 'flyinshadow/php_localvarcheck.vim', { 'for': 'php' }
Plug 'shawncplus/phpcomplete.vim', { 'for': 'php' }
" js support
Plug 'othree/yajs.vim', {'for': 'javascript'}
Plug 'heavenshell/vim-jsdoc', {'for': 'javascript'}
call plug#end()

"-----------------
" plugin settings
"-----------------
" ctrlp
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|png)$',
  \ 'link': '',
  \ }
let g:ctrlp_cmd = 'CtrlPMRU' " mru first
" vim-surround
" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_save=1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {
  \'mode': 'active',
  \'passive_filetypes': ['go'],
  \'active_filetypes': ['php']
  \}
let g:syntastic_php_checkers = ['php', 'phpmd']
let g:syntastic_php_phpmd_post_args='unusedcode'
let g:syntastic_php_phpcs_args='--standard=psr2'
" indent_guides
filetype plugin indent on
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'tagbar', 'unite']
" tagbar
nmap <F8> :TagbarToggle<CR>
let g:tagbar_left = 1
" vim-tags
let g:vim_tags_auto_generate = 1
let g:vim_tags_project_tags_command = "/usr/local/bin/ctags . 2>/dev/null"
" quick run
let g:quickrun_config={'*': {'split': ''}}
set splitbelow
nnoremap <C-c> :<C-u>bw! \[quickrun\ output\]<CR>
" memolist.vim
let g:memolist_path = "~/Documents/memo"
" ctags
nnoremap <C-]> g<C-]>zz " ctags
" supertab
let g:SuperTabDefaultCompletionType = "context"
" grepper
xmap gs  <plug>(GrepperOperator)
nnoremap <leader>g :Grepper -tool git<cr>
command! -nargs=+ -complete=file GrepperGit Grepper -noprompt -tool git -query <args>
"Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#tab_nr_type = 1
" nerdtree
map <C-n> :NERDTreeToggle<CR>
nnoremap <silent> <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden = 1 " show hidden files in default
let g:NERDTreeShowBookmarks=1
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__', 'node_modules', 'bower_components']
let NERDTreeWinSize=35
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
autocmd FileType nerdtree setlocal nolist
let g:NERDTreeNodeDelimiter = "\u00a0"

"-----------------
" general
"-----------------
syntax enable
set encoding=utf-8
set nobackup
set modeline
set fileencoding=utf-8
set fileencodings=utf-8,euc-jp,cp932
set fileformats=unix,dos,mac
set ambiwidth=double
set expandtab " change tab to space
set tabstop=4
set softtabstop=4
set autoindent
set smartindent
set shiftwidth=4
filetype plugin indent on
augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.sh setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.html setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.vue setf js setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd Filetype php  :set omnifunc=phpcomplete#CompletePHP
set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,],~
set showmatch
set wildmenu
set visualbell
set nocursorline
autocmd InsertEnter,InsertLeave * set cursorline! "  cursorline highlight only insert mode
set hlsearch
set ruler
set noswapfile
set hidden
set title
set wildmenu wildmode=list:full
set ignorecase
set incsearch
set splitright
set tags=tags,../tags,../../tags,../../../tags,../../../../tags,../../../../../tags
set grepprg=grep\ -rnIH\ --exclude-dir=.svn\ --exclude-dir=.git
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
nnoremap <C-s> :set paste<CR>
noremap <Space>w :w<Space>!<Space>sudo<Space>tee<Space>><Space>/dev/null<Space>%
autocmd InsertLeave * set nopaste
nnoremap <F3> :noh<CR> " no highlight
set number
set history=700
set showcmd
set clipboard=unnamed
set lazyredraw
set ttyfast
set wrapscan
set shortmess+=I
vnoremap v $h " select endline by vv
" color
set background=dark
try
    colorscheme zenburn
catch
endtry
highlight clear SignColumn
set t_Co=256
highlight Normal ctermbg=none
nnoremap <F1> <Esc>
inoremap <F1> <Esc>

" binary settings
augroup BinaryXXD
  autocmd!
  autocmd BufReadPre  *.bin let &binary =1
  autocmd BufReadPost * if &binary | silent %!xxd -g 1
  autocmd BufReadPost * set ft=xxd | endif
  autocmd BufWritePre * if &binary | %!xxd -r | endif
  autocmd BufWritePost * if &binary | silent %!xxd -g 1
  autocmd BufWritePost * set nomod | endif
augroup END

" vimgrep
autocmd QuickFixCmdPost *grep* cwindow

" user definition cmd
command DelBrankLine v/./d
command DelMathcLine g//d
command ExecReplaceFiles argdo %s///g | update
aug QFClose
  au!
  au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
aug END
