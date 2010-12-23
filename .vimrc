set tabstop=4
set number
"set smartindent
colorscheme twilight
syntax on
filetype plugin indent on
function! PlaySound()
  silent! exec '!aplay ~/.vim/support/type.wav 2>/dev/null&'
endfunction
"autocmd CursorMovedI * call PlaySound()

