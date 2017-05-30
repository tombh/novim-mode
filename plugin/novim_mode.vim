let s:save_cpo = &cpo
set cpo&vim

let s:settings = {
  \ 'use_general_app_shortcuts': 1,
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

" Plugin entry point
call novim_mode#StartNoVimMode()

let &cpo = s:save_cpo
unlet s:save_cpo
