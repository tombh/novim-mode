# No vim keybindings mode

_Work In Progress_

Some, indeed many, may say this is counter-productive or even sacrilegious. But Vim is a lot more than just a keybinding paradigm; firstly it has one of the richest plugin ecosystems of any editor, but also it is a --if not *the* most-- ubiquitous text editor and has been battle tested for over 25 years. There are more reasons to use it than merely its famous shortcut vocabulary. This plugin is an attempt to expose everything else about Vim without the overhead of learning to use Normal mode The Right Way.

Vim itself already has support for something similar in its optional [`mswin.vim`](https://github.com/vim/vim/blob/master/runtime/mswin.vim) config file. However it still assumes the relevance of Normal mode and `SHIFT+INSERT` combinations. Whereas this plugin attempts to avoid Normal mode unless absolutely necessary, say for interacting with the NERDTree buffer.

## Installation

Use your favourite plugin manager, eg, for vim-plug;

`Plug 'tombh/novim-mode'`

## Usage

Most keybindings should work as you might expect from, say Atom or Sublime Text; `CTRL+S` to save, etc. However there are some differences;
  * `CTRL+Z` does not undo, as that is already a well-established *nix shortcut for backgrounding a program. 
  * CTRL/HOME/END/PAGEUP/PAGEDOWN keys don't work during selection mode. Though large areas of text can be quickly selected with the mouse. It may end up being easier to simulate selection mode with Vim's default Visual mode.
  * There seems to be a bug where only `SHIFT+TAB` and not `TAB` works for indenting during selection mode. Again this may be fixed by simulating selection mode with Visual mode in the future.

### Keybindings

  * `CTRL+S`: Saves the current file
  * `SHIFT+ARROW`: Enter selection mode
  * `CTRL+C`: Copy selection
  * `CTRL+X`: Cut selection
  * `CTRL+V`: Paste current selection
  * `CTRL+A`: Select all
  * `TAB`: Indent selected text [currently broken]
  * `SHIFT+TAB`: Unindent selected text
  * `CTRL+F`: Find text. `F3` and `SHIFT+F3` find next/previous
  * `CTRL+U/R`: Undo/Redo
  * `CTRL+K`: Delete current line
  * `CTRL+D`: Duplicate current line
  * `ALT+UP/DOWN`: Move current line up/down
  * `CTRL+Q`: Exit window/tab/split/quickfix/etc

