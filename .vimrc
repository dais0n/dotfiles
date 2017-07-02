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
Plug 'tpope/vim-surround'
Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdcommenter'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'glidenote/memolist.vim'
Plug 'tyru/open-browser.vim' 
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
" vim-surround
" indent_guides
filetype plugin indent on
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'tagbar', 'unite']

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
filetype plugin indent on
augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.sh setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.html setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.vue setf js setlocal tabstop=2 softtabstop=2 shiftwidth=2
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
set number
set history=700
set showcmd
set clipboard=unnamed
set lazyredraw
set ttyfast
set showbreak=↪
set wrapscan
vnoremap v $h " select endline by vv
" color
set background=dark
colorscheme solarized
set t_Co=256
highlight Normal ctermbg=none

" auto parentheses
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>

" zenkaku space
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction
if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme * call ZenkakuSpace()
        autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
    augroup END
    call ZenkakuSpace()
endif

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

" complete
set completeopt=menuone
for k in split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_",'\zs')
  exec "imap " . k . " " . k . "<C-N><C-P>"
endfor

imap <expr> <TAB> pumvisible() ? "\<Down>" : "\<Tab>"

