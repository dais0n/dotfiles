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
set encoding=UTF-8
set statusline=%F  " filename
set statusline+=%m " check mode change
set statusline+=%r " check readonly
set statusline+=%h " help page
set statusline+=%w " preview
" rightstatus
set statusline+=%=
set statusline+=[ENC=%{&fileencoding}] " file encoding
set statusline+=[LOW=%l/%L] " display rows
function! g:Date()
    return strftime("%x %H:%M")
endfunction
set statusline+=\ \%{g:Date()}
set laststatus=2  " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set completeopt=menuone
"-----------------
" plugin
"-----------------
call plug#begin('~/.vim/plugged')
Plug 'ctrlpvim/ctrlp.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'tpope/vim-surround'
Plug 'scrooloose/syntastic'
Plug 'tomtom/tcomment_vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'glidenote/memolist.vim'
Plug 'tyru/open-browser.vim'
Plug 'thinca/vim-quickrun'
Plug 'ntpeters/vim-better-whitespace'
Plug 'jiangmiao/auto-pairs'
Plug 'kannokanno/previm'
Plug 'majutsushi/tagbar'
Plug 'szw/vim-tags'
Plug 'ervandew/supertab'
Plug 'easymotion/vim-easymotion'
Plug 'kshenoy/vim-signature'
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
call plug#end()
" ctrlp
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|png)$',
  \ 'link': '',
  \ }
let g:ctrlp_cmd = 'CtrlPMRU' " mru first
" nerdtree
map <C-n> :NERDTreeToggle<CR>
nnoremap <silent> <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden = 0 " show hidden files in default
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__', 'node_modules', 'bower_components']
let g:NERDTreeLimitedSyntax = 1
" vim-surround
" syntastic
let g:syntastic_check_on_save=1
let g:syntastic_auto_loc_list=1
let g:syntastic_loc_list_height=6
let g:syntastic_javascript_checkers = ['eslint']
set statusline+=%#warningmsg# "エラーメッセージの書式
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
" indent_guides
filetype plugin indent on
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'tagbar', 'unite']
" quick run
let g:quickrun_config={'*': {'split': ''}}
set splitbelow

nnoremap <C-c> :<C-u>bw! \[quickrun\ output\]<CR>
" tagbar
nmap <F8> :TagbarToggle<CR>
" ctags
nnoremap <C-]> g<C-]>zz
" vim tags
let g:vim_tags_auto_generate = 1
" easy motion
map <Leader> <Plug>(easymotion-prefix)

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-x>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" lightline vim
set laststatus=2

"-----------------
" general
"-----------------
syntax enable
set encoding=utf-8
set nobackup
set modeline
set fileencoding=utf-8
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
set fileformats=unix,dos,mac
set ambiwidth=double
set expandtab " change tab to space
set tabstop=4
set softtabstop=4
set autoindent
set smartindent
set shiftwidth=4
set clipboard=unnamedplus
filetype plugin indent on
augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.sh setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.html setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.vue setf js setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.yaml setlocal ts=2 sts=2 sw=2 shiftwidth=2
augroup END
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
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
nnoremap <C-c> :set paste<CR>
autocmd InsertLeave * set nopaste
nnoremap <F3> :noh<CR>
set number
set history=700
set showcmd
set lazyredraw
set ttyfast
set showbreak=↪
set wrapscan
vnoremap v $h " select endline by vv
" color
set background=dark
try
    colorscheme solarized
catch
endtry
set t_Co=256
highlight Normal ctermbg=none

" auto parentheses
"inoremap {<Enter> {}<Left><CR><ESC><S-o>
"inoremap [<Enter> []<Left><CR><ESC><S-o>
"inoremap (<Enter> ()<Left><CR><ESC><S-o>

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

