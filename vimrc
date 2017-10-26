set langmenu=en_US.UTF-8
language messages en
colors wombat
set guifont=Terminus:h9:cRUSSIAN

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/vimfiles/bundle/Vundle.vim
set shell=C:/cygwin64/bin/bash
set shellcmdflag=--login\ -c
set shellxquote='
set noshellslash
set hidden

call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'wincent/command-t'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'zettaface/unisyntax'
Plugin 'aperezdc/vim-template'
Plugin 'yggdroot/indentline'
Plugin 'kshenoy/vim-signature'
Plugin 'ap/vim-css-color'
Plugin 'mhinz/vim-signify'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'embear/vim-foldsearch'
Plugin 'tobase'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set secure

set lines=30 columns=130
set laststatus=2

set statusline=%f

set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set nowrap
let g:indentLine_indentLevel=20
set synmaxcol=250

"gitgutter
let g:gitgutter_git_executable="C:/Program Files/Git/bin/git.exe"

set hlsearch
"set colorcolumn=120   
syntax on
set showmatch
set number
set cursorline

set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0

set backspace=indent,eol,start
set virtualedit=block

" Hide toolbar
set guioptions-=T

" Move swap files into .vim instead of working dir
set backupdir=~/vimfiles/backup//
set directory=~/vimfiles/swap//
set undodir=~/vimfiles/undo//

let g:SignatureMarkTextHL = "Mark"

let g:airline_theme='base16_brewer'

command! -nargs=? -range Dec2hex call s:Dec2hex(<line1>, <line2>, '<args>')
function! s:Dec2hex(line1, line2, arg) range
  if empty(a:arg)
    if histget(':', -1) =~# "^'<,'>" && visualmode() !=# 'V'
      let cmd = 's/\%V\<\d\+\>/\=printf("0x%02X",submatch(0)+0)/g'
    else
      let cmd = 's/\<\d\+\>/\=printf("0x%02X",submatch(0)+0)/g'
    endif
    try
      execute a:line1 . ',' . a:line2 . cmd
    catch
      echo 'Error: No decimal number found'
    endtry
  else
    echo printf('%02X', a:arg + 0)
  endif
endfunction

command! -nargs=? -range Hex2dec call s:Hex2dec(<line1>, <line2>, '<args>')
function! s:Hex2dec(line1, line2, arg) range
  if empty(a:arg)
    if histget(':', -1) =~# "^'<,'>" && visualmode() !=# 'V'
      let cmd = 's/\%V\%(0x\)\=\x\+/\=submatch(0)+0/g'
    else
      let cmd = 's/0x\x\+/\=submatch(0)+0/g'
    endif
    try
      execute a:line1 . ',' . a:line2 . cmd
    catch
      echo 'Error: No hex number starting "0x" found'
    endtry
  else
    echo (a:arg =~? '^0x') ? a:arg + 0 : ('0x'.a:arg) + 0
  endif
endfunction

" return the first run of binary digits found in string {bin} converted
" to (lower case) hex digits
func! Bin2Hex(bin)
    let bin = matchstr(a:bin, '[01]\+')
    if bin == ""
        return "0"
    endif
    let bin = repeat("0", PadSize(strlen(bin), 4)). bin
    let runs = split(bin, '....\zs')
    call map(runs, 's:fourbd2hd(v:val)')
    return join(runs, '')
endfunc


command! -nargs=? -range ParseTlv call s:FormatTlv()
function! s:FormatTlv() range
    let n = @n
    silent! normal gv"ny
    echo system("TlvFormatter -mir -data ".@n)
    let @n = n
    " bonus: restores the visual selection
    normal! gv
endfunction

command! -nargs=? -range ParseTlvNW call s:FormatTlvNewWindow()
function! s:FormatTlvNewWindow() range
    let n = @n
    silent! normal gv"ny
    let @n = system("TlvFormatter -mir -data ".@n)
    bo vnew
    set syntax=tlvparser
    vertical resize 60
    set buftype=nofile
    execute "normal! P<c-w>h"
    let @n = n
    " bonus: restores the visual selection
    normal! gv
endfunction

command! -nargs=? -range FormatTlvInPlace call s:FormatTlvInPlace()
function! s:FormatTlvInPlace() range
    let n = @n
    silent! normal gv"ny
    let @n = system("TlvFormatter -flat -mir -data ".@n)
    normal! gv"np
    let @n = n
    normal! gv
endfunction

vnoremap fhtd :Hex2dec<cr>
vnoremap fhta :<c-u>s/\%V\%(0x\)\?\(\x\x\)/\=nr2char(printf("%d", "0x".submatch(1)))/g<cr><c-l>`<
vnoremap fdth :Dec2hex<cr>
vnoremap fath :<c-u>s/\%V./\=printf("%X",char2nr(submatch(0)))/g<cr><c-l>`<
vnoremap fhtt :<c-u>s/\%V\(\%(\x\x\)\+\)/\=nr2char(printf("%d", "0x".submatch(1)))/g<cr><c-l>`<
vnoremap tp :ParseTlv<cr>
vnoremap tf :FormatTlvInPlace<cr>
vnoremap tw :ParseTlvNW<cr>

nmap <silent> <F4> :FSHere<cr>
nmap <silent> <c-n> :NERDTree<cr>

set langmap=∏ÈˆÛÍÂÌ„¯˘Áı˙Ù˚‚‡ÔÓÎ‰Ê˝ˇ˜ÒÏËÚ¸·˛®…÷” ≈Õ√ÿŸ«’⁄‘€¬¿œ–ŒÀƒ∆›ﬂ◊—Ã»“‹¡ﬁ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>

nmap ∆ :
" yank
nmap Õ Y
nmap Á p
nmap Ù a
nmap ˘ o
nmap „ u
nmap « P
