# Tip of the hat to terryma/vim-multiple-cursors for this style
# of testing Vim.
require 'spec_helper'

describe 'Basic editing' do
  specify 'writing simple text' do
    initial <<-EOF
    EOF

    type 'hello world'

    final <<-EOF
      hello world
    EOF
  end

  specify '<Home> goes to first non-whitespace char' do
    initial <<-EOF
      justified
         indented
    EOF

    type '<Down><End><Home>!'

    final <<-EOF
      justified
         !indented
    EOF
  end

  specify 'copy and paste' do
    initial <<-EOF
      copy me
    EOF

    type '<S-End><C-c><Esc><Space><C-v>'

    final <<-EOF
      copy me copy me
    EOF
  end

  specify 'CTRL+ARROW jumps by word' do
    initial <<-EOF
      one two three four
    EOF

    type '<C-Right>X<C-Right>Y<C-Left>Z'

    final <<-EOF
      one Xtwo ZYthree four
    EOF
  end
end

describe 'Selecting' do
  specify 'select all and replace' do
    initial <<-EOF
      select me more, just to make sure
			even a hard line
    EOF

    type '<C-a>gone'

    final <<-EOF
      gone
    EOF
  end

  specify 'paste over selection' do
    initial <<-EOF
      cut me and paste over me
    EOF

    7.times { type '<S-Right>' }
    type '<C-x>'
    10.times { type '<Right>' }
    7.times { type '<S-Right>' }
    type '<C-v>'

    final <<-EOF
      and paste cut me
    EOF
  end

  specify 'selecting from middle of line to end' do
    initial <<-EOF
      a line of text
    EOF

    6.times { type '<Right>' }
    type '<S-End>'
    type '!'

    final <<-EOF
      a line!
    EOF
  end

  specify 'selecting from middle of line to beginning' do
    initial <<-EOF
      a line of text
    EOF

    7.times { type '<Right>' }
    type '<S-Home>'
    type '!'

    final <<-EOF
      !of text
    EOF
  end

  specify 'ALT+] indents' do
    initial <<-EOF
      a line of text
    EOF

    type '<S-End>'
    type '<M-]>'
    type '<M-]>'

    final_with_indents "\t\ta line of text\n"
  end

  specify 'Shift-Tab or ALT+[ indents' do
    initial <<-EOF
      a line of text
    EOF

    type '<S-End>'
    type '<M-]>'
    type '<M-]>'
    type '<S-Tab>'

    final_with_indents "\ta line of text\n"
  end

  specify 'CTRL+D selects the word under the cursor' do
    initial <<-EOF
      a line of text
    EOF

    4.times { type '<Right>' }
    type '<C-D>X'

    final <<-EOF
      a X of text
    EOF
  end
end

describe 'Home/End behaviour for long, non-wrapped code lines' do
  before(:each) do
    # We need a small screen so that lines go off the edge of it.
    @vim_options = [
      # A single buffer can't be resized, so create a split of the buffer
      'vsplit',
      'vertical resize 6'
    ]
  end

  specify 'HOME/END move to start/end of line off-screen' do
    initial <<-EOF
      line line line line
    EOF

    type '<End>X<Home>Y'

    final <<-EOF
      Yline line line lineX
    EOF
  end

  specify 'SHIFT+END selects line, even if off-screen' do
    initial <<-EOF
      line line line line!
    EOF

    type '<S-End><S-Left>x'

    final <<-EOF
      x!
    EOF
  end

  specify 'SHIFT+HOME selects line, even if off-screen' do
    initial <<-EOF
      !line line line line
    EOF

    type '<End><S-Home><S-Right>x'

    final <<-EOF
      !x
    EOF
  end
end

describe 'Wrapped text' do
  before(:each) do
    @vim_options = [
      # A single buffer can't be resized, so create a split of the buffer
      'vsplit',
      'vertical resize 6'
    ]
    use_extension 'txt'
  end

  specify 'move up/down one wrapped line' do
    initial <<-EOF
      line line line line
    EOF

    type '<Down><Down>down '
    type '<Up>up '

    final <<-EOF
      line line up down line line
    EOF
  end

  specify 'select wrapped line below' do
    initial <<-EOF
      line1 line2 line3 line4
    EOF

    type '<Down><S-Down><S-Down>'
    type '!'

    final <<-EOF
      line1 !line4
    EOF
  end

  specify 'select wrapped line above' do
    initial <<-EOF
      line1 line2 line3 line4
    EOF

    type '<Down><Down><S-Up><S-Up>'
    type '!'

    final <<-EOF
      !line3 line4
    EOF
  end

  specify '<End> goes to end of wrapped line' do
    initial <<-EOF
      line line line line
    EOF

    type '<End>!'

    final <<-EOF
      line! line line line
    EOF
  end

  specify '<Home> goes to beginning of wrapped line' do
    initial <<-EOF
      line line line line
    EOF

    type '<Down><Home>!'

    final <<-EOF
      line !line line line
    EOF
  end
end

describe 'Pane control' do
  specify 'moving to another pane' do
    # Open Quickfix window (auto focuses to it)
    type '<M-;>:copen<CR>'
    pane_type = vim.command 'echo &buftype'
    expect(pane_type).to eq 'quickfix'

    # Focus back to file
    type '<M-Up>'
    pane_type = vim.command 'echo &buftype'

    expect(pane_type).to eq ''
  end

  specify 'closing a pane' do
    type '<M-;>vsplit README.md<CR>'
    buffer_id = vim.command "echo bufnr('%')"
    expect(buffer_id).to eq '2'

    type '<C-w>'
    buffer_id = vim.command "echo bufnr('%')"
    expect(buffer_id).to eq '1'
  end
end
