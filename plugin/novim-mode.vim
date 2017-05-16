" Make sure insert mode is the default mode when opening/switching to files
function! InsertMode()
  if &buftype ==# 'nofile'
     \|| !&modifiable
     \|| &readonly
     \|| bufname('%') =~# 'NERD_tree_'
    exe "set noinsertmode"
  else
    exe "set insertmode"
  endif
endfunction

augroup start_insertmode
  autocmd!
  autocmd BufEnter * call InsertMode()
augroup END

" Copy and paste stuff
" TODO:
"   * Doesn't work when cursor is on the first col
"   * Support SHIFT+ARROW in visual mode
inoremap <S-Left> <Esc><Right>v<Left>
inoremap <S-Right> <Esc><Right>v<Right>
inoremap <S-Up> <Esc><Right>v<Up>
inoremap <S-Down> <Esc><Right>v<Down>
inoremap <C-V> <Esc>pi<Right>
vnoremap <C-C> y<Esc>i
vnoremap <C-X> d<Esc>i

" Indenting
" The `gv` returns you to the exact same selection, so you can repeat the
" command
vnoremap <Tab> ><Esc>gv
vnoremap <S-Tab> <<Esc>gv

" CTRL+q to exit pane/app
inoremap <C-Q> <C-O>:q<CR>
" Useful for exiting buffers like NERDTree that don't use insertmode
nnoremap <C-Q> :q<CR>

" Find
inoremap <C-F> <C-O>/
inoremap <F3> <C-O>n
" Clears highlighting. NB. Overriding ESC makes it very hard to get into
" NORMAL mode.
inoremap <Esc> <C-O>:noh<CR>

" Undo/redo
" Doesn't use Ctrl+Z because that's already a significant *nix shortcut
inoremap <silent> <C-U> <C-O>u
inoremap <silent> <C-R> <C-O><C-R>

" CTRL+s saves
inoremap <silent> <C-S> <C-O>:update<CR>

" CTRL+k deletes the current line
inoremap <silent> <C-K> <C-O>"_dd

" CTRL+d duplicates current line
" TODO: don't put it in vim's clipboard, so CTRL+V works as expected
inoremap <silent> <C-D> <C-O>yy<C-O>p

" Alt+/- moves the current line up and down
inoremap <silent> <M--> <C-O>:m -2<CR>
inoremap <silent> <M-=> <C-O>:m +1<CR>

" Home goes back to the first non-whitespace character of the line
inoremap <silent> <Home> <C-O>^

" Allow text to wrap in text files
au BufNewFile,BufRead *.txt,*.md,*.markdown setlocal linebreak spell
" Make arrow keys move through wrapped lines
" TODO:
"   * Scroll window 1 wrapped soft line at a time rather an entire block of wrapped
"     lines.
au BufNewFile,BufRead *.txt,*.md,*.markdown inoremap <buffer> <Up> <C-O>gk
au BufNewFile,BufRead *.txt,*.md,*.markdown inoremap <buffer> <Down> <C-O>gj
