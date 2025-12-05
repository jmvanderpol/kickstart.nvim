-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Set netrw to disabled to replace with nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable Perl and PHP Language Support
vim.g.loaded_perl_provider = 1
vim.g.loaded_php_provider = 1

require 'custom.options'
require 'custom.keymaps'
require 'custom.autocommands'
require 'custom.plugins'
require 'custom.lsp-config'


-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
