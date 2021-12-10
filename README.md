#  No Vim Keybindings Mode [![Build Status](https://travis-ci.org/tombh/novim-mode.svg?branch=master)](https://travis-ci.org/tombh/novim-mode)

Some, indeed many, may say this is counter-productive or even sacrilegious. But Vim is a lot more than just a keybinding paradigm; firstly it has one of the richest plugin ecosystems of any editor, but also it is a -if not *the* most- ubiquitous text editor that's been battle tested for over 25 years. There are more reasons to use it than merely its famous shortcut vocabulary.

This plugin is an attempt to expose everything else about Vim without the overhead of cultivating Normal Mode fluency. This is not a rebellion, it is merely a manifestation of the distinction between Vim the editor and Vim the keybinding paradigm. Please do not dismiss Normal Mode just because this plugin exists, give `vimtutor` a try, modal editing is popular for a reason.

Vim itself already has support for something similar in its optional [`mswin.vim`](https://github.com/vim/vim/blob/master/runtime/mswin.vim) config file. However it still assumes the necessity of Normal Mode and such heritage as `SHIFT+INSERT`-style combinations. This plugin however, attempts to avoid Normal Mode unless absolutely necessary, say for interacting with the NERDTree buffer, wherein Insert Mode has no purpose.

The name `novim-mode` is a nod to the prevalence of 'vim-mode' plugins and extensions available in environments outside the editor, such as web browsers. In the same way that the love of Vim has led to efforts to export it elsewhere, 'novim-mode' is the love of 'conventional' editing imported into Vim.

## Installation

Use your favourite plugin manager, eg, for vim-plug;

`Plug 'tombh/novim-mode'`

Note that Vim before v7.5 and Neovim before v0.1.5 have a bug where Insert Mode is inappropriately set for some panes.

## Usage

Most keybindings should work as you might expect from, say Atom or Sublime Text; `SHIFT+ARROW` to select and `CTRL+C/V` to copy/paste. But don't expect Vim to completely bend to your will, it is still useful to familiarise yourself with some of Vim's basic concepts. For instance you may on occasion find yourself stuck in a particular Vim mode, like when pasting text without 'Paste Mode' then inserted text can trigger random mappings. In such case `CTRL+Q` may not kill Vim and you'll need to find a way of getting to Normal Mode and typing `:q` then `<RETURN>`. Such is life with Vim, this plugin is highly unlikely to ever change that. (BTW conventional pasting is on by default, but to exit an errant 'Paste Mode' use `:set nopaste`.)

If you are new to Vim, then perhaps the only remaining confusion after installing this plugin will be about where files go when you open new ones. This question will be answered by Vim's concept of 'buffers'. You may wish to install something like [vim-buftabline](https://github.com/ap/vim-buftabline) to give a familiar list of open files along the top of the editor.

### Keybindings

#### Vim in the terminal
Both Vim and Neovim can be used both as GUI apps and in the terminal. However, original Vim in the terminal has problems with many key combinations - essentially most combinations that are not a plain `CTRL+KEY`. To get around this you can use the [vim-fixkey](https://github.com/drmikehenry/vim-fixkey) plugin. It does have some caveats, which you can read about in its docs, but basically it just makes recording macros a little bit more tricky because of the timing between `Esc` combinations. `vim-fixkey` also doesn't enable `ALT+non-alphanumeric` combinations, but `novim-mode` usually has alphanumeric siblings which you can still use. However, if you are not particularly tied to Vim, you can use Neovim in the terminal which has much better support for key combinations and will work without the  need for `vim-fixkey`. Note that the GUI versions of both Vim and Neovim also don't have these key combination problems.

Most terminal emulators (ie. `xterm`, `rxvt`, `PuTTY`, etc) default to intercepting `CTRL+S` to suspend output (`CTRL+Q` unsuspends if you're wondering), if so you will need to disable this behaviour to use `novim-mode`'s shortcuts for saving and quitting. Most often you simply need to add the following to your `~/.bashrc`, `~/.zshrc` or similar:

```sh
stty -ixon
stty stop undef
```

However some GUI terminals also have their own settings for suspension. For instance Konsole, which can be unset by going to `Settings -> Configure Profile -> Choose current profile -> Edit Profile -> Advanced Tab` and disabling `Enable flow control using Ctrl+S and Ctrl+Q`

One further common problem is that `tmux` can change key combination behaviour, most notably for `SHIFT+ARROW` combinations, to overcome this add `set-window-option -g xterm-keys` to your `~/.tmux.conf` config.

#### General editor shortcuts
  * `CTRL+N`: Open a new file.
  * ~~`CTRL+O`: Open an existing file.~~ Causes too many conflicts, use (`ALT+;`, type `edit`) or a file manager instead
  * `CTRL+S`: Saves the current file.
  * `CTRL+Q`: Quit Vim.
  * `CTRL+G`: Goto line.
  * `ALT+;` or `ALT+c`: Vim's command prompt.
  * `ALT+o`: Replaces native `CTRL+O` to give one-off Normal Mode commands.

#### Pane controls
  * `ALT+ARROW`: Change pane/buffer focus.
  * `CTRL+W`: Closes current pane-like thing. Also closes associated quickfix and location panes.

#### Selecting, copy and paste
  * `SHIFT+ARROW`: Select text
  * `CTRL+C`: Copy selection or copy line if no selection.
  * `CTRL+X`: Cut selection or cut line if no selection.
  * `CTRL+V`: Paste current selection.
  * `CTRL+A`: Select all.
  * `CTRL+D`: Select word under cursor. Use something like [vim-multicursors](https://github.com/terryma/vim-multiple-cursors) for multi cursor support.
  * `CTRL+L`: Select line under cursor, repetition selects more lines.

#### Indenting
  * `TAB` or `ALT+]`: Indent current line or selected text. _`TAB` currently broken for Neovim_
  * `SHIFT+TAB` or `ALT+[`: Unindent current line or selected text.

#### Finding, replacing
  * `CTRL+F`: Find text. When text is selected that selection is searched for.
  * `F3` and `SHIFT+F3`: Find next and previous occurences.
  * `CTRL+H`: Find and replace. `[FIND]` and `[REPLACE]` are prepopulated.

#### Undoing
  * `CTRL+Z` or `CTRL+U`: Undo.
  * `CTRL+Y`: Redo.

#### Other text manipulation tricks
  * `CTRL+LEFT/RIGHT`: Move cursor per word (works in selection as well).
  * `CTRL+ALT+k`: Delete current line. _Currently broken in terminal Vim_
  * `CTRL+ALT+d`: Duplicate current line. _Currently broken in terminal Vim_
  * `CTRL+UP/DOWN`: Move current line or selected text up/down.

_Note that `CTRL`-based shortcuts are paired with uppercase letters in these docs because
Vim does not recognise the difference between cases when using `CTRL` combinations and
documenting in uppercase implies something of this distinction._

### Interoperability
When adding a new binding of your own that needs Normal mode, you should use `<C-O>` before the targeted command, for example;
```vim
" Ensure CtrlP doesn't get overridden by autocomplete in insertmode
inoremap <C-P> <C-O>:CtrlP<CR>
```

Overriding or disabling shortcuts in this plugin can be done in several ways. The simplest way is to use:
```vim
let g:novim_mode_use_shortcuts = 0
inoremap ... custom mapping ...
call novim_mode#StartNoVimMode()
```

Shortcuts are also grouped roughly under the headings described above, so you may be able to disable one of the following:
```vim
let g:novim_mode_use_general_app_shortcuts = 1
let g:novim_mode_use_pane_controls = 1
let g:novim_mode_use_copypasting = 1
let g:novim_mode_use_indenting = 1
let g:novim_mode_use_finding = 1
let g:novim_mode_use_undoing = 1
let g:novim_mode_use_text_tricks = 1

" Small fixes to HOME and PAGEUP behaviour
let g:novim_mode_use_editor_fixes = 1
" Allows scrolling through wrapped lines one visual line at a time
let g:novim_mode_use_better_wrap_navigation = 1
```

Lastly you can unmap a mapping using commands such as `nunmap`, `iunmap`, `sunmap`, etc.

### Known issues
  * Because a lot of the keybindings trigger brief switches to NORMAL mode in the background, then be careful of plugins that cause a delay between switching modes. I know that `vim-airline` in particular has this problem.
  * In Neovim there seems to be a bug where only `SHIFT+TAB` and not `TAB` works for indenting during selection mode.
  * Mapping `<CTRL+M>` internally means mapping `<RETURN>`. This is a throwback to Vim's days as a pure terminal application.
  * `CTRL+BACKSPACE` internally represents `<CTRL+H>`, which can be annoying. Again this is a throwback to Vim's days as a pure terminal application.
