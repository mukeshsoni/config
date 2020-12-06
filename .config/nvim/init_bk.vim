call plug#begin('~/.local/share/nvim/plugged')
Plug 'svermeulen/vimpeccable'
Plug 'svermeulen/vimpeccable-lua-vimrc-example'
function! s:local_plug(package_name) abort " {{{
  if isdirectory(expand("~/local_vim_plugins/" . a:package_name))
    execute "Plug '~/local_vim_plugins/" . a:package_name . "'"
  else
    execute "Plug 'mukeshsoni/" . a:package_name . "'"
  endif
endfunction
" {{{
call plug#end()

" Enable true color 启用终端24位色
set termguicolors

" If i don't set the background myself, neovim tries to detect it
" from the terminal. And for me it detects background as dark for tmux
" but not for regular Terminal.
set background=dark
set t_Co=256

