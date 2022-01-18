" novim_mode.vim - 'Conventional' editor keybindings plugin
" Author:       tombh
" Version:      0.1
"
" ============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:settings = {
  \ 'use_general_app_shortcuts': 1,
  \ 'use_tab_shortcuts': 1,
  \ 'use_editor_fixes': 1,
  \ 'use_pane_controls': 1,
  \ 'use_copypasting': 1,
  \ 'use_indenting': 1,
  \ 'use_finding': 1,
  \ 'use_undoing': 1,
  \ 'use_text_tricks': 1,
  \ 'use_better_wrap_navigation': 1,
  \ 'use_shortcuts': 1
\}

" Fetches existing values from user and sets defaults if not set.
function! s:init_settings(settings)
  for [key, value] in items(a:settings)
    let sub = ''
    if type(value) == 0
      let sub = '%d'
    elseif type(value) == 1
      let sub = '"%s"'
    endif
    let fmt = printf("let g:novim_mode_%%s=get(g:, 'novim_mode_%%s', %s)",
          \ sub)
    exec printf(fmt, key, key, value)
  endfor
endfunction

call s:init_settings(s:settings)

if has('timers') == 0
  echo "Novim-mode: Your Vim version (Vim <7.5 or Neovim <0.1.5) doesn't "
  echo "support `timer()`, which causes a bug where Insert Mode is "
  echo "inappropriately set for some panes."
endif

" Plugin entry point
call g:novim_mode#StartNoVimMode()

let &cpo = s:save_cpo
unlet s:save_cpo
