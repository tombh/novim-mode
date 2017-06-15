require 'vimrunner'
require 'vimrunner/rspec'

Vimrunner::RSpec.configure do |config|
  #  Set to false to use an instance per test (slower, but can be easier
  #  to manage).
  config.reuse_server = false

  # Decide how to start a Vim instance. In this block, an instance should be
  # spawned and set up with anything project-specific.
  config.start_vim do
    vim = Vimrunner.start

    # Load the plugin
    plugin_path = File.expand_path('../..', __FILE__)
    vim.add_plugin(plugin_path, 'plugin/novim_mode.vim')

    # The returned value is the Client available in the tests.
    vim
  end
end

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

def type(string)
  string.scan(/<.*?>|./).each do |key|
    if key =~ /<.*>/
      vim.feedkeys "\\#{key}"
    else
      vim.feedkeys key
    end
  end
end
