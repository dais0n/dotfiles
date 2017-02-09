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
" filename
set statusline=%F
" check change
set statusline+=%m
" check readonly
set statusline+=%r
" help page
set statusline+=%h
" preview
set statusline+=%w
" rightstatus
set statusline+=%=
" file encoding
set statusline+=[ENC=%{&fileencoding}]
" display rows
set statusline+=[LOW=%l/%L]
" Always display the statusline in all windows
set laststatus=2 
" Always display the tabline, even if there is only one tab
set showtabline=2

"----------------
" dein
"----------------
" directory
let s:dein_dir = expand('~/.vim/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" git clone
if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " load toml
  let s:toml = '~/.dein.toml'
  let s:lazy_toml = '~/.dein_lazy.toml'
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif
if dein#check_install(['vimproc'])
  call dein#install(['vimproc'])
endif
if dein#check_install()
  call dein#install()
endif

" theme
set t_Co=256
highlight Normal ctermbg=none
colorscheme jellybeans
let g:jellybeans_overrides = {
\    'background': { 'ctermbg': 'none', '256ctermbg': 'none' },
\}

" Unite.vim
" start in insertmode
let g:unite_enable_start_insert=1
" activate history yank
let g:unite_source_history_yank_enable =1
"unite prefix key
nmap U [unite]

" current directory
nnoremap <silent> [unite]a :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" recently files
nnoremap <silent> [unite]f :<C-u>Unite<Space>buffer file_mru<CR>
nnoremap <silent> [unite]d :<C-u>Unite<Space>directory_mru<CR>
" buffer
nnoremap <silent> [unite]b :<C-u>Unite<Space>buffer<CR>
" registry
nnoremap <silent> [unite]r :<C-u>Unite<Space>register<CR>
" tab
nnoremap <silent> [unite]t :<C-u>Unite<Space>tab<CR>
" yank histor 
nnoremap <silent> [unite]h :<C-u>Unite<Space>history/yank<CR>
" outline
nnoremap <silent> [unite]o :<C-u>Unite<Space>outline<CR>
" grep
nnoremap <silent> [unite]g :<C-u>Unite grep:. -buffer-name=search-buffer<CR>

"unite.vim keymappings
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
    " end unite by <C-j>
    nmap <buffer> <C-j><C-j> <Plug>(unite_exit)
endfunction"}}}

let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1
" unite search by ag
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif

"accelarate j and k
nmap j <Plug>(accelerated_jk_gj_position)
nmap k <Plug>(accelerated_jk_gk_position)

"quick run
let g:quickrun_config={'*': {'split': ''}}
set splitbelow

nnoremap <C-c> :<C-u>bw! \[quickrun\ output\]<CR>

"Note: This option must be set in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
" When a capital letter is included in input, neocomplete does
" not ignore the upper- and lowercase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()
" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.go = '\h\w\.\w*'
" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
"
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> pumvisible() ? "\<C-n>" : neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:loaded_syntastic_python_pylint_checker = 0

"indent_guides
filetype plugin indent on
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'tagbar', 'unite']

" go settings
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_fmt_command = "goimports"
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

" js settings
au BufRead,BufNewFile *.jsx set filetype=javascript.jsx
let g:jsx_ext_required = 0

"-----------------
" general
"----------------- 
syntax enable
set encoding=utf-8
set nobackup
set modeline
filetype plugin indent on
set fileencoding=utf-8
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
set fileformats=unix,dos,mac
set ambiwidth=double
" change tab to space
set expandtab
set tabstop=4
set softtabstop=4
set autoindent
set smartindent
set shiftwidth=4
augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.sh setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END
set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,],~
set cursorline
set showmatch
" complete commands
set wildmenu
" delete beepsound
set visualbell

set hlsearch
set ruler
set noswapfile
set title
set wildmenu wildmode=list:full
" search settings
set ignorecase
set incsearch
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
set number
set history=5000
set showcmd
set clipboard=unnamed
set lazyredraw
set ttyfast
set showbreak=↪
set wrapscan
" mac keybinds
inoremap <C-j> <Esc>
noremap <C-j> <ESC>
vnoremap <C-j> <ESC>
nnoremap ; :
nnoremap : ;
" select endline by vv 
vnoremap v $h
" color
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
" paste
" Turn off paste mode when leaving insert
autocmd InsertLeave * set nopaste
if &term =~ "xterm"
    let &t_ti .= "\e[?2004h"
    let &t_te .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    noremap <special> <expr> <Esc>[200~ XTermPasteBegin("0i")
    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
    cnoremap <special> <Esc>[200~ <nop>
    cnoremap <special> <Esc>[201~ <nop>
endif
