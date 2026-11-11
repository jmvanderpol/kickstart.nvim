local startup_started = vim.uv.hrtime()
require('config.startup-stats').setup(startup_started)

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used
vim.g.mapleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Set netrw to disabled to replace with neo-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- These plugins use Lua, LSP servers, or standalone executables rather than remote hosts.
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_php_provider = 0

-- Mason's tree-sitter-cli package uses a platform-specific binary name.
-- nvim-treesitter invokes it as `tree-sitter`, so expose that command name.
local mason_bin = vim.fn.stdpath 'data' .. '/mason/bin'
local tree_sitter_command = mason_bin .. '/tree-sitter'
if vim.fn.executable 'tree-sitter' ~= 1 and vim.fn.executable(tree_sitter_command) ~= 1 then
  local mason_package = vim.fn.stdpath 'data' .. '/mason/packages/tree-sitter-cli/'
  local candidates = {
    mason_package .. 'tree-sitter-macos-arm64',
    mason_package .. 'tree-sitter-macos-x64',
    mason_package .. 'tree-sitter-linux-arm64',
    mason_package .. 'tree-sitter-linux-x64',
    mason_package .. 'tree-sitter.exe',
  }
  for _, candidate in ipairs(candidates) do
    if vim.fn.executable(candidate) == 1 then
      vim.fn.mkdir(mason_bin, 'p')
      if vim.uv.fs_lstat(tree_sitter_command) then
        vim.uv.fs_unlink(tree_sitter_command)
      end
      pcall(vim.uv.fs_symlink, candidate, tree_sitter_command)
      break
    end
  end
end
local path_separator = vim.fn.has 'win32' == 1 and ';' or ':'
vim.env.PATH = mason_bin .. path_separator .. (vim.env.PATH or '')

-- Setup leanpack.nvim plugin manager
-- Optional legacy machine settings must run before plugin configuration.
if vim.fn.filereadable(vim.fn.stdpath 'config' .. '/lua/environment.lua') == 1 then
  require 'environment'
end

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

require 'config.options'
require 'config.keymaps'
require 'config.autocommands'
require 'config.lsp-config'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
