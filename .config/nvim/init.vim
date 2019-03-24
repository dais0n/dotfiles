"-----------------
" plugin
"-----------------
call plug#begin('~/.local/share/nvim/plugged')
"common
Plug 'w0rp/ale'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
Plug 'ntpeters/vim-better-whitespace'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tyru/open-browser.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jnurmine/Zenburn'
Plug 'tomtom/tcomment_vim'
Plug 'jiangmiao/auto-pairs'
" nerd tree
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" lsp
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
" go support
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries' }
" markdown support
Plug 'glidenote/memolist.vim'
Plug 'kannokanno/previm'
" nginx
Plug 'chr4/nginx.vim'
call plug#end()
" ctrlp
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|png)$',
  \ 'link': '',
  \ }
let g:ctrlp_cmd = 'CtrlPMRU' " mru first

" lsp
let g:lsp_diagnostics_enabled = 0
" if executable('gopls')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'gopls',
"         \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
"         \ 'whitelist': ['go'],
"         \ })
" endif
autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()
"au FileType go nnoremap <C-]> :<C-u>LspDefinition<CR>

" ale
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_sign_error = '⨉'
let g:ale_sign_warning = '⚠ '
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
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

" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline_theme = 'base16'

" vim-go
let g:go_fmt_command = "goimports"
let g:go_version_warning = 0
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_auto_sameids = 1
let g:go_auto_type_info = 1
let g:go_gocode_unimported_packages = 1
let g:go_def_mode='gopls'
let g:go_doc_keywordprg_enabled = 0

"-----------------
" general
"-----------------
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
tnoremap <Esc> <C-\><C-n>
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
