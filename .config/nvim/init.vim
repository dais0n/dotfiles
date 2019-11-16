"-----------------
" plugin
"-----------------
call plug#begin('~/.local/share/nvim/plugged')
"common
Plug 'w0rp/ale'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ntpeters/vim-better-whitespace'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tyru/open-browser.vim'
Plug 'jnurmine/Zenburn'
Plug 'tomtom/tcomment_vim'
Plug 'jiangmiao/auto-pairs'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
" nerd tree
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" lsp
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': ':call coc#util#install()'}
" go support
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries' }
" markdown support
Plug 'glidenote/memolist.vim'
Plug 'kannokanno/previm'
" nginx
Plug 'chr4/nginx.vim'
call plug#end()
" lsp
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" ale
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_fix_on_save = 0
let g:ale_fix_on_text_changed = 'never'
let g:ale_sign_error = '⨉'
let g:ale_sign_warning = '⚠ '
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_sign_column_always = 1

" easymotion
let g:EasyMotion_do_mapping = 0 "Disable default mappings
map <Space> <Plug>(easymotion-overwin-f2)

" not stop completion $ & /
setlocal iskeyword+=$
setlocal iskeyword+=-

" memolist.vim
let g:memolist_path = "~/Documents/memo"

" indent guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'tagbar', 'unite']

" nerdtree
map <C-n> :NERDTreeToggle<CR>
nnoremap <silent> <C-n> :NERDTreeToggle<CR>
let g:NERDTreeShowBookmarks=1
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__', 'node_modules', 'bower_components']
let NERDTreeWinSize=32

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let g:NERDTreeDirArrows=0
if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
endif
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '

" vim-go
let g:go_fmt_command = "goimports"

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
nnoremap <Space>h :FzfHistory<cr>
nnoremap <Space>b :FzfBuffers<cr>
nnoremap <Space>f :FzfRg<cr>

"-----------------
" general
"-----------------
syntax enable

" statusline
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

" user definition cmd
command DelBrankLine v/./d
command DelMathcLine g//d
command ExecReplaceFiles argdo %s///g | update
aug QFClose
  au!
  au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
aug END

