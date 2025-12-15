return {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {},
    keys = {
      -- Navigation
      {
        ']c',
        function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            require('gitsigns').nav_hunk 'next'
          end
        end,
        desc = 'Jump to next git [c]hange',
      },
      {
        '[c',
        function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            require('gitsigns').nav_hunk 'prev'
          end
        end,
        desc = 'Jump to previous git [c]hange',
      },

      -- Actions
      -- visual mode
      { '<leader>h', group = 'GitSigns Hunk Operations' },
      {
        '<leader>hs',
        "<cmd>Gitsigns stage_hunk :lua { vim.fn.line '.', vim.fn.line 'v' }<cr>",
        mode = { 'v' },
        desc = 'git [s]tage hunk',
      },
      {
        '<leader>hr',
        "<cmd>Gitsigns reset_hunk :lua { :vim.fn.line '.', vim.fn.line 'v'}<cr>",
        mode = { 'v' },
        desc = 'git [r]eset hunk',
      },
      {
        '<leader>hs',
        '<cmd>Gitsigns stage_hunk<cr>',
        desc = 'git [s]tage hunk',
      },
      {
        '<leader>hr',
        '<cmd>Gitsigns reset_hunk<cr>',
        desc = 'git [r]eset hunk',
      },
      {
        '<leader>hS',
        '<cmd>Gitsigns stage_hunk<cr>',
        desc = 'git [S]tage buffer',
      },
      {
        '<leader>hu',
        '<cmd>Gitsigns undo_stage_hunk<cr>',
        desc = 'git [u]ndo stage hunk',
      },
      {
        '<leader>hR',
        '<cmd>Gitsigns reset_buffer<cr>',
        desc = 'git [R]eset buffer',
      },
      {
        '<leader>hp',
        '<cmd>Gitsigns preview_hunk<cr>',
        desc = 'git [p]review hunk',
      },
      {
        '<leader>hb',
        '<cmd>Gitsigns blame_line<cr>',
        desc = 'git [b]lame line',
      },
      {
        '<leader>hd',
        '<cmd>Gitsigns diffthis<cr>',
        desc = 'git [d]iff against index',
      },
      {
        '<leader>hD',
        "<cmd>Gitsigns diffthis '@'<cr>",
        desc = 'git [D]iff against last commit',
      },
      {
        '<leader>tb',
        '<cmd>gitsigns toggle_current_line_blame<cr>',
        desc = '[T]oggle git show [b]lame line',
      },
      {
        '<leader>tD',
        '<cmd>Gitsigns toggle_deleted<cr>',
        desc = '[T]oggle git show [D]eleted',
      },
    },
  },

  --  Use: event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded.
  --
  -- Because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      preset = 'helix',
    },
    keys = {
      -- Document existing key chains
      { '<leader>c', group = '[C]ode' },
      { '<leader>c_', group = '[C]ode', hidden = true },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>d_', group = '[D]ocument', hidden = true },
      { '<leader>h', group = 'Git Signs:' },
      { '<leader>h_', hidden = true },
      { '<leader>r', group = '[R]ename' },
      { '<leader>r_', hidden = true },
      { '<leader>s', group = '[S]earch' },
      { '<leader>s_', hidden = true },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>t_', hidden = true },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>w_', hidden = true },
      -- visual mode
      { '<leader>h', group = 'Git [H]unk' },
      { '<leader>h_', hidden = true },
    },
  },
  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'css',
        'diff',
        'html',
        'javascript',
        'lua',
        'luadoc',
        'markdown',
        'python',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      -- Prefer git instead of curl in order to improve connectivity in some environments
      require('nvim-treesitter.install').prefer_git = true
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
  {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup {
        -- your personal icons can go here (to override)
        -- you can specify color or cterm_color instead of specifying both of them
        -- DevIcon will be appended to `name`
        override = {
          zsh = {
            icon = '',
            color = '#428850',
            cterm_color = '65',
            name = 'Zsh',
          },
        },
        -- globally enable different highlight colors per icon (default to true)
        -- if set to false all icons will have the default icon's color
        color_icons = true,
        -- globally enable default icons (default to false)
        -- will get overriden by `get_icons` option
        default = true,
        -- globally enable "strict" selection of icons - icon will be looked up in
        -- different tables, first by filename, and if not found by extension; this
        -- prevents cases when file doesn't have any extension but still gets some icon
        -- because its name happened to match some extension (default to false)
        strict = true,
        -- set the light or dark variant manually, instead of relying on `background`
        -- (default to nil)
        variant = 'light|dark',
      }
    end,
    opts = {},
  },
  {
    'Isrothy/neominimap.nvim',
    dependencies = { 'lewis6991/gitsigns.nvim' },
    version = 'v3.*.*',
    enabled = true,
    lazy = false, -- NOTE: NO NEED to Lazy load
    -- Optional
    keys = {
      { '<leader>n', group = 'NeoMiniMap' },
      { '<leader>n_', hidden = true },
      -- Global Minimap Controls
      { '<leader>nm', '<cmd>Neominimap Toggle<cr>', desc = 'Toggle global minimap' },
      { '<leader>no', '<cmd>Neominimap Enable<cr>', desc = 'Enable global minimap' },
      { '<leader>nc', '<cmd>Neominimap Disable<cr>', desc = 'Disable global minimap' },
      { '<leader>nr', '<cmd>Neominimap Refresh<cr>', desc = 'Refresh global minimap' },

      -- Window-Specific Minimap Controls
      { '<leader>nwt', '<cmd>Neominimap WinToggle<cr>', desc = 'Toggle minimap for current window' },
      { '<leader>nwr', '<cmd>Neominimap WinRefresh<cr>', desc = 'Refresh minimap for current window' },
      { '<leader>nwo', '<cmd>Neominimap WinEnable<cr>', desc = 'Enable minimap for current window' },
      { '<leader>nwc', '<cmd>Neominimap WinDisable<cr>', desc = 'Disable minimap for current window' },

      -- Tab-Specific Minimap Controls
      { '<leader>ntt', '<cmd>Neominimap TabToggle<cr>', desc = 'Toggle minimap for current tab' },
      { '<leader>ntr', '<cmd>Neominimap TabRefresh<cr>', desc = 'Refresh minimap for current tab' },
      { '<leader>nto', '<cmd>Neominimap TabEnable<cr>', desc = 'Enable minimap for current tab' },
      { '<leader>ntc', '<cmd>Neominimap TabDisable<cr>', desc = 'Disable minimap for current tab' },

      -- Buffer-Specific Minimap Controls
      { '<leader>nbt', '<cmd>Neominimap BufToggle<cr>', desc = 'Toggle minimap for current buffer' },
      { '<leader>nbr', '<cmd>Neominimap BufRefresh<cr>', desc = 'Refresh minimap for current buffer' },
      { '<leader>nbo', '<cmd>Neominimap BufEnable<cr>', desc = 'Enable minimap for current buffer' },
      { '<leader>nbc', '<cmd>Neominimap BufDisable<cr>', desc = 'Disable minimap for current buffer' },

      ---Focus Controls
      { '<leader>nf', '<cmd>Neominimap Focus<cr>', desc = 'Focus on minimap' },
      { '<leader>nu', '<cmd>Neominimap Unfocus<cr>', desc = 'Unfocus minimap' },
      { '<leader>ns', '<cmd>Neominimap ToggleFocus<cr>', desc = 'Switch focus on minimap' },
    },
    init = function()
      -- The following options are recommended when layout == "float"
      vim.opt.wrap = false
      vim.opt.sidescrolloff = 36 -- Set a large value

      --- Put your configuration here
      ---@type Neominimap.UserConfig
      vim.g.neominimap = {
        auto_enable = true,
      }
    end,
  },
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },
  {
    'prettier/vim-prettier',
    event = 'VimEnter',
    config = function() end,
  },
  {
    'saghen/blink.pairs',
    version = '*',
    event = 'InsertEnter',
    -- download prebuilt binaries from github releases
    dependencies = 'saghen/blink.download',
    --- @module 'blink.pairs'
    --- @type blink.pairs.Config
    opts = {
      mappings = {
        -- you can call require("blink.pairs.mappings").enable()
        -- and require("blink.pairs.mappings").disable()
        -- to enable/disable mappings at runtime
        enabled = true,
        cmdline = true,
        -- or disable with `vim.g.pairs = false` (global) and `vim.b.pairs = false` (per-buffer)
        -- and/or with `vim.g.blink_pairs = false` and `vim.b.blink_pairs = false`
        disabled_filetypes = {},
        -- see the defaults:
        -- https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L14
        pairs = {},
      },
      highlights = {
        enabled = true,
        -- requires require('vim._extui').enable({}), otherwise has no effect
        cmdline = true,
        groups = {
          'BlinkPairsOrange',
          'BlinkPairsPurple',
          'BlinkPairsBlue',
        },
        unmatched_group = 'BlinkPairsUnmatched',

        -- highlights matching pairs under the cursor
        matchparen = {
          enabled = true,
          -- known issue where typing won't update matchparen highlight, disabled by default
          cmdline = false,
          -- also include pairs not on top of the cursor, but surrounding the cursor
          include_surrounding = false,
          group = 'BlinkPairsMatchParen',
          priority = 250,
        },
      },
      debug = false,
    },
  },
}
