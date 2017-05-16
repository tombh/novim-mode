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

" Mostly changes the way selection works.
" See: http://vimdoc.sourceforge.net/htmldoc/gui.html#:behave
" An extract from the docs about the difference between `behave mswin`
" and `behave xterm`:
"               mswin              xterm
"  'selectmode' 'mouse,key'        ''
"  'mousemodel' 'popup'            'extend'
"  'keymodel'   'startsel,stopsel' ''
"  'selection'  'exclusive'        'inclusive'
behave mswin

" Copy and paste stuff
inoremap <C-V> <C-O>p
vnoremap <C-C> y
vnoremap <C-X> x

" CTRL-A for selecting all text
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G
vnoremap <C-A> <C-C>gggH<C-O>G

" Indenting
" TODO: TAB doesn't work in mswin selection mode, but SHIFT+TAB does??
vnoremap <Tab> >
vnoremap <S-Tab> <

" CTRL+q to exit pane/app
inoremap <C-Q> <C-O>:q<CR>
" Useful for exiting buffers like NERDTree that don't use insertmode
nnoremap <C-Q> :q<CR>

" Find
inoremap <C-F> <C-O>/
" Find next
inoremap <F3> <C-O>n
" Find previous
inoremap <S-F3> <C-O>N
" Clears highlighting. NB. Overriding ESC makes it very hard to get into
" NORMAL mode.
inoremap <silent> <Esc> <C-O>:noh<CR>

" Undo/redo
" Doesn't use Ctrl+Z because that's already a significant *nix shortcut
" Unfortunately Vim can't use uppercase (shifted) key combos, otherwise
" we'd use CTRL+SHIFT+U here.
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
"   * Make End key move to end of current wrapped piece of line.
"   * Scroll window 1 wrapped soft line at a time rather an entire block of wrapped
"     lines.
au BufNewFile,BufRead *.txt,*.md,*.markdown inoremap <buffer> <Up> <C-O>gk
au BufNewFile,BufRead *.txt,*.md,*.markdown inoremap <buffer> <Down> <C-O>gj
