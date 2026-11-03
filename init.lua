-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used
vim.g.mapleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Set netrw to disabled to replace with neo-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable Perl and PHP Language Support
vim.g.loaded_perl_provider = 1
vim.g.loaded_php_provider = 1

-- Setup leanpack.nvim plugin manager
vim.pack.add { { src = 'https://github.com/ntk148v/leanpack.nvim' } }

-- Setup leanpack with import from lua/plugins/
require('leanpack').setup {
  { import = 'plugins' },
  defaults = {
    lazy = true,
  },
  performance = {
    vim_loader = true,
    rtp_prune = true,
  },
}

require 'environment'
require 'config.options'
require 'config.keymaps'
require 'config.autocommands'
require 'config.lsp-config'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
