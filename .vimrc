set tabstop=4
set sw=4
set number
"set smartindent
colorscheme twilight
syntax on
filetype plugin indent on
filetype plugin on
set ofu=syntaxcomplete#Complete
function! PlaySound()
  silent! exec '!aplay ~/.vim/support/type.wav 2>/dev/null&'
endfunction
"autocmd CursorMovedI * call PlaySound()

