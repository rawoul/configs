if exists('loaded_std_headers')
  finish
endif
let loaded_std_headers=1

aug StdHeader
  au!
  au BufNewFile *.h silent call <SID>NewHFile("h")
  au BufNewFile *.hh silent call <SID>NewHFile("hh")
aug END

function s:NewHFile(skelfile)
  execute "r $HOME/.vim/skel/" . a:skelfile . ".tpl"
  normal kdd
  execute "% s,@HEADER-NAME@," . toupper(expand('%:t:r')) . "_" . toupper(expand('%:e')) . "_" . ",ge"
  normal G{k
endfunction
