# Tip of the hat to terryma/vim-multiple-cursors for this style
# of testing Vim.
require 'spec_helper'

TEST_FILE = 'test_file.txt'.freeze

def write_file_content(string)
  string = normalize_string_indent(string)
  File.open(TEST_FILE, 'w') { |f| f.write(string) }
  vim.edit TEST_FILE
end

def load_file_content
  vim.write
  IO.read(TEST_FILE).strip
end

def before(string)
  options.each { |x| vim.command(x) } if options
  write_file_content(string)
end

def after(string)
  expect(load_file_content).to eq normalize_string_indent(string)
end

def type(string)
  string.scan(/<.*?>|./).each do |key|
    if key =~ /<.*>/
      vim.feedkeys "\\#{key}"
    else
      vim.feedkeys key
    end
  end
end

describe 'Basic editing' do
  let(:options) {}

  specify 'writing simple text' do
    before <<-EOF
    EOF

    type 'hello world'

    after <<-EOF
      hello world
    EOF
  end

  specify 'copy and paste' do
    before <<-EOF
      copy me
    EOF

    # Conventional behaviour shouldn't need the <End> right?
    type '<S-End><C-c><End><Space><C-v>'

    after <<-EOF
      copy me copy me
    EOF
  end

  specify 'select all and replace' do
    before <<-EOF
      select me
    EOF

    # Conventional behaviour shouldn't need the <End>?
    type '<C-a>gone'

    after <<-EOF
      gone
    EOF
  end
end

describe 'Pane control' do
  let(:options) {}

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
    # Open Netrw file manager in a sidebar
    type '<M-;>:Vexplore<CR>'
    buffer_id = vim.command "echo bufnr('%')"
    expect(buffer_id).to eq '2'

    # Close Netrw pane
    type '<C-w>'
    buffer_id = vim.command "echo bufnr('%')"
    expect(buffer_id).to eq '1'
  end
end
