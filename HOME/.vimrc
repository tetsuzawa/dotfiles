call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'Townk/vim-autoclose'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-fugitive'
Plug 'vim/killersheep'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'godlygeek/tabular'
Plug 'udalov/kotlin-vim'

call plug#end()

nmap <F5> :!python %
inoremap jj <Esc>
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up>   gk
nnoremap - :<C-u>e %:h<Cr>

autocmd BufWrite *.{h,py,cpp} set fenc=utf-8
if has('win32')
    "Windows"
elseif system("uname")=="Darwin\n"
    "Mac"
elseif system("uname")=="Linux\n"
    "unix"
endif
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set list
set rtp+=/usr/local/opt/fzf
