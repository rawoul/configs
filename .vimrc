" GENERAL OPTIONS
set nocompatible
set shortmess=fmxoOtTI

" load bundles
filetype off
set rtp+=~/.vim/bundle/nofrils

" allow to switch buffer without saving
set hidden
" bind arrows
set ww=<,>,[,]
" ignore these files
set wildignore=*.o,*.obj,*~,.*.swp
" undo levels
set ul=200
" disable swap file
set uc=0

" INPUT OPTIONS
" use mouse
set mouse=a

" DISPLAY OPTIONS
" set syntax on
syntax on
" term options
set termencoding=&encoding
colorscheme default
set background=dark
if &t_Co == 88
    hi SpecialKey ctermfg=80
    hi Pmenu ctermbg=darkblue
    hi PmenuSel ctermbg=81
    hi DiffChange ctermbg=32
    hi DiffText ctermbg=48
    hi CursorColumn ctermbg=80
    hi CursorLine cterm=NONE ctermbg=80
elseif &t_Co == 256
    hi SpecialKey ctermfg=237
    hi Pmenu ctermbg=24 ctermfg=lightgray
    hi PmenuSel ctermbg=39 ctermfg=white
    hi DiffAdd ctermbg=24
    hi DiffDelete ctermbg=67 ctermfg=24
    hi DiffChange ctermbg=52
    hi DiffText ctermbg=88
    hi CursorColumn ctermbg=235
    hi CursorLine cterm=NONE ctermbg=235
else
    hi SpecialKey ctermfg=0 cterm=bold
endif
" no bip
set novisualbell
" set term title
set title
" smoother changes
set ttyfast
" show status line when the window is split
set laststatus=1
" show insert, replace, none
set showmode
" location ruler
set ruler
" ruler format
set rulerformat=%55(%{strftime('%a\ %b\ %e\ %H:%M\')}\ %5l,%-6(%c%V%)\ %P%)
" show matching brackets
set showmatch
" always display a line above the cursor
set scrolloff=1
" completion
"set wildmenu
set wildmode=list:full
" show current command
set showcmd
" show tabs
set list listchars=tab:>-
" highlight trailing spaces
match Error /\s\+$/
" show cursor position
"set cursorcolumn
set cursorline

" EDITING OPTIONS
" convert to another locale only if encoding is different
set fileencoding=
" cd to the current file's directory
set autochdir
" backspace can go over lines
set backspace=indent,eol,start
" keep cursor on same column when doing page movement
set nostartofline
" tab length in spaces
set tabstop=8
" indent shift
set shiftwidth=8
" fake tabs
set softtabstop=0
" smart tabs at the beginning of a line
set smarttab
" do not replace tabs by spaces
set noexpandtab
" use auto indenting
set autoindent
" set smartindent
set smartindent
set cinoptions=g0,t0,Ws,m1,:0

" SEARCH OPTIONS
" higlight search
set hlsearch
" ignore case for search
set ignorecase
" override ignore case when using uppercase
set smartcase
" incremental search
set incsearch

" BACKUP OPTIONS
" disable backups
set nobackup

" FILETYPES
" load extensions
filetype plugin indent on
" for all text files set 'textwidth' to 80 characters.
au FileType text,tex,mail setlocal textwidth=80
" execute script when using :make
au FileType sh setlocal makeprg=./$*
" fbxbus
au BufNewFile,BufRead *.fbxbus setf fbxbus
" lua template
au BufNewFile,BufRead *.hlpt setf html
" config
au BufNewFile,BufRead Config*.in setf kconfig
" html
au FileType html,xhtml setlocal sw=4 ts=4
" lua
au FileType lua setlocal sw=4 sts=4 et
" perl
au FileType perl setlocal sw=2 et
" c options
augroup c
	autocmd!
	autocmd FileType c,cpp setlocal formatprg=indent
	autocmd FileType cpp setlocal et ts=8 sw=4 sts=4
	autocmd FileType c setlocal cinoptions+=(0
	"autocmd FileType c,cpp setlocal cindent
	"autocmd FileType c,cpp imap <buffer> { {<CR> <BS><CR>}<Up><End>
augroup end
let g:c_syntax_for_h = 1

" BINDINGS
" Function keys
nmap <F3> :A<CR>
nmap <F4> yy:A<CR>G{kpA;<Esc>
map <F5> :ccl<CR>:wall!<CR>:make<CR>
map <F6> :cp<CR>
map <F7> :cn<CR>
map <silent> <F8> :Tlist<CR>
map <F12> :set ts=8<CR>:set sw=3<CR>:set sts=8<CR>:set noet<CR>:set cino=>5n-2f0{2e-2<CR>
" Tab always inserts a tab
nnoremap <TAB> i<TAB><Esc>
" Y = y$ not yy.  More intuative
noremap Y y$
" toggle paste
set pastetoggle=<F9>
" get rid of Windows ^M and blank end of lines
"autocmd BufWrite * silent! ks|%s#\s*\r\?$##|'s

" PLUGINS SETTINGS
" Taglist
let Tlist_Show_One_File = 1
" comments
let g:EnhCommentifyRespectIndent = 'Y'
" use CSS to convert text to html (using TOhtml command)
let html_use_css = 1
" load man plugin
runtime ftplugin/man.vim
