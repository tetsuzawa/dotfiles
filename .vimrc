call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'davidhalter/jedi-vim'
Plug 'Townk/vim-autoclose'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-fugitive'

call plug#end()

nmap <F5> :!python %
inoremap jj <Esc>
set number
autocmd BufWrite *.{h,py,cpp} set fenc=utf-8
if has('win32')
    "Windows"
elseif system("uname")=="Darwin\n"
    "Mac"
elseif system("uname")=="Linux\n"
    "unix"
endif
set tabstop=4
set shiftwidth=4
set smartindent
set list
