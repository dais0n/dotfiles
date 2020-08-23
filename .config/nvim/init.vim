"-----------------
"
" plugins
"
"-----------------
call plug#begin('~/.local/share/nvim/plugged')
" common
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tyru/open-browser.vim'
Plug 'tomtom/tcomment_vim'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'cohama/lexima.vim' " auto close
" nerdtree
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-rhubarb'
" lsp
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'liuchengxu/vista.vim'
" go
Plug 'mattn/vim-goimports', { 'for':  'go'}
Plug 'sebdah/vim-delve', { 'for':  'go'}
" markdown
Plug 'plasticboy/vim-markdown'
Plug 'kannokanno/previm'
Plug 'mattn/vim-maketable'
" nginx
Plug 'chr4/nginx.vim'
" theme
Plug 'jnurmine/Zenburn'
call plug#end()

" open-browser.vim
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" fzf.vim
command! -bang -nargs=* Rg
            \ call fzf#vim#grep(
            \   'rg --line-number --no-heading '.shellescape(<q-args>), 0,
            \   fzf#vim#with_preview({'options': '--exact --reverse'}, 'right:50%:wrap'))

" nerdtree
nnoremap <C-n> :NERDTreeToggle<CR>

" coc
function! s:completion_check_bs()
    let l:col = col('.') - 1
    return !l:col || getline('.')[l:col - 1] =~? '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>completion_check_bs() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
"Autocmd CursorHold * silent call CocUpdagteAsync('highlight')
" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" not stop completion $ & /
setlocal iskeyword+=$
setlocal iskeyword+=-

" indent guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" vista
" Executive used when opening vista sidebar without specifying it.
" See all the avaliable executives via `:echo g:vista#executives`.
let g:vista#renderer#enable_icon = 0
let g:vista_default_executive = 'coc'

" fzf
let g:fzf_command_prefix = 'Fzf'
let g:fzf_layout = { 'down': '~40%' }
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
nnoremap <silent> <C-p> :FzfFiles<CR>
nnoremap <silent> <C-p> :FzfHistory<cr>
nnoremap <Space>f :FzfRg<cr>

autocmd CursorHold * silent call CocActionAsync('highlight')

" markdown
let g:vim_markdown_folding_disabled = 1

"-----------------
" general
"-----------------
if executable('python2')
    let g:python_host_prog=$PYENV_ROOT.'/versions/neovim-2/bin/python'
endif
if executable('python3')
    let g:python3_host_prog=$PYENV_ROOT.'/versions/neovim-3/bin/python'
endif

syntax enable

set sh=zsh
set completeopt=menuone
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
set autowrite
filetype plugin on
filetype plugin indent on
augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.sh setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.json setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.html setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.xml setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.yml setlocal tabstop=2 softtabstop=2 shiftwidth=2
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
set hidden
set title
set wildmenu wildmode=list:full
set ignorecase
set incsearch
set splitright
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
noremap <Space>w :w<Space>!<Space>sudo<Space>tee<Space>><Space>/dev/null<Space>%
set number
set history=700
set showcmd
set clipboard=unnamed
set lazyredraw
set ttyfast
set wrapscan
set shortmess+=I
vnoremap v $h " select endline by vv
" changelog
let g:changelog_timeformat="%Y-%m-%d"
let g:changelog_username="dais0n<t.omura8383@gmail.com>"

" turn terminal to normal mode with escape
set splitbelow
tnoremap <Esc> <C-\><C-n>
" start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
" open terminal on ctrl+n
function! OpenTerminal()
  split term://zsh
  resize 15
endfunction
nnoremap <c-x> :call OpenTerminal()<CR>

"-----------------
" color
"-----------------
try
    colorscheme zenburn
catch
endtry
highlight clear SignColumn
set t_Co=256
highlight Normal ctermbg=none

"-----------------
" statusline
"-----------------
set statusline=%<
set statusline+=[%n]
set statusline+=%m
set statusline+=%r
set statusline+=%h
set statusline+=%w
set statusline+=%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}
set statusline+=%y
set statusline+=\
if winwidth(0) >= 130
	set statusline+=%F
else
	set statusline+=%t
endif
set statusline+=%=


"-----------------
" user cmd
"-----------------
command DelBrankLine v/./d
command DelMathcLine g//d
command ExecReplaceFiles argdo %s///g | update
aug QFClose
  au!
  au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
aug END

