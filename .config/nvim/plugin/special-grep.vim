nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>repOperator(visualmode())<cr>

function s:GrepOperator(type) abort
  let saved_unamed_register  = @@

  if a:type ==# 'v'
    execute "normal! `<v`>y"
  elseif a:type ==# 'char'
    execute "normal! `[y`]"
  else
    return
  endif

  echom shellescape(@@)
  silent execute "grep! -R " . shellescape(@@) . " ."
  copen

  let @@ = saved_unamed_register
endfunction
