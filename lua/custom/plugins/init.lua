-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
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
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      sources = {
        'filesystem',
        'buffers',
        'git_status',
        'document_symbols',
      },
      source_selector = {
        winbar = true,
        statusline = false,
      },
      icon = {
        folder_closed = '',
        folder_open = '',
        folder_empty = '󰉖',
        folder_empty_open = '󰷏',
        -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
        -- then these will never be used.
        default = '*',
        highlight = 'NeoTreeFileIcon',
      },
      filesystem = {
        window = {
          mappings = {
            ['H'] = 'toggle_hidden',
            ['/'] = 'fuzzy_finder',
            --["/"] = {"fuzzy_finder", config = { keep_filter_on_submit = true }},
            --["/"] = "filter_as_you_type", -- this was the default until v1.28
            ['D'] = 'fuzzy_finder_directory',
            -- ["D"] = "fuzzy_sorter_directory",
            ['#'] = 'fuzzy_sorter', -- fuzzy sorting using the fzy algorithm
            ['f'] = 'filter_on_submit',
            ['<C-x>'] = 'clear_filter',
            ['<bs>'] = 'navigate_up',
            ['.'] = 'set_root',
            ['[g'] = 'prev_git_modified',
            [']g'] = 'next_git_modified',
            ['i'] = 'show_file_details', -- see `:h neo-tree-file-actions` for options to customize the window.
            ['b'] = 'rename_basename',
            ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
            ['oc'] = { 'order_by_created', nowait = false },
            ['od'] = { 'order_by_diagnostics', nowait = false },
            ['og'] = { 'order_by_git_status', nowait = false },
            ['om'] = { 'order_by_modified', nowait = false },
            ['on'] = { 'order_by_name', nowait = false },
            ['os'] = { 'order_by_size', nowait = false },
            ['ot'] = { 'order_by_type', nowait = false },
          },
          fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
            ['<down>'] = 'move_cursor_down',
            ['<C-n>'] = 'move_cursor_down',
            ['<up>'] = 'move_cursor_up',
            ['<C-p>'] = 'move_cursor_up',
            ['<Esc>'] = 'close',
            ['<S-CR>'] = 'close_keep_filter',
            ['<C-CR>'] = 'close_clear_filter',
            ['<C-w>'] = { '<C-S-w>', raw = true },
            {
              -- normal mode mappings
              n = {
                ['j'] = 'move_cursor_down',
                ['k'] = 'move_cursor_up',
                ['<S-CR>'] = 'close_keep_filter',
                ['<C-CR>'] = 'close_clear_filter',
                ['<esc>'] = 'close',
              },
            },
            -- ["<esc>"] = "noop", -- if you want to use normal mode
            -- ["key"] = function(state, scroll_padding) ... end,
          },
        },
        filtered_items = {
          visible = false, -- when true, they will just be displayed differently than normal items
          force_visible_in_empty_folder = false, -- when true, hidden files will be shown if the root folder is otherwise empty
          children_inherit_highlights = true, -- whether children of filtered parents should inherit their parent's highlight group
          show_hidden_count = true, -- when true, the number of hidden items in each folder will be shown as the last entry
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_hidden = true, -- only works on Windows for hidden files/directories
          hide_by_name = {
            '.DS_Store',
            'thumbs.db',
            --"node_modules",
          },
          hide_by_pattern = { -- uses glob style patterns
            --"*.meta",
            --"*/src/*/tsconfig.json"
          },
          always_show = { -- remains visible even if other settings would normally hide it
            --".gitignored",
          },
          always_show_by_pattern = { -- uses glob style patterns
            --".env*",
          },
          never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
            --".DS_Store",
            --"thumbs.db"
          },
          never_show_by_pattern = { -- uses glob style patterns
            --".null-ls_*",
          },
        },
      },
    },
  },
  {
    'antosha417/nvim-lsp-file-operations',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-neo-tree/neo-tree.nvim', -- makes sure that this loads after Neo-tree.
    },
    config = function()
      require('lsp-file-operations').setup()
    end,
  },
  {
    's1n7ax/nvim-window-picker',
    version = '2.*',
    config = function()
      require('window-picker').setup {
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
            -- if the buffer type is one of following, the window will be ignored
            buftype = { 'terminal', 'quickfix' },
          },
        },
      }
    end,
  },
  {
    'maxmx03/fluoromachine.nvim',
    config = function()
      local fm = require 'fluoromachine'
      fm.setup {
        transparent = false,
        glow = true,
        theme = 'fluoromachine',
      }
      vim.cmd.colorscheme 'fluoromachine'
    end,
  },
  {},
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobject
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- require('mini.files').setup()

      -- Minimal Fuzzy Search UI
      require('mini.fuzzy').setup()

      -- Window with buffer text overview
      --
      -- Default configuration has a `window` that is non-`highlight`able
      -- editor has map on `side`: `right`
      -- with a `width` of `10`
      -- local minimap = require 'mini.map'
      -- minimap.setup {
      --   window = {
      --     focusable = false,
      --     side = 'right',
      --     width = 10,
      --     zindex = 100,
      --   },
      --   symbols = {
      --     encode = minimap.gen_encode_symbols.dot '3x2',
      --   },
      -- }

      -- vim.keymap.set('n', '<Leader>mc', MiniMap.close)
      -- vim.keymap.set('n', '<Leader>mf', MiniMap.toggle_focus)
      -- vim.keymap.set('n', '<Leader>mo', MiniMap.open)
      -- vim.keymap.set('n', '<Leader>mr', MiniMap.refresh)
      -- vim.keymap.set('n', '<Leader>ms', MiniMap.toggle_side)
      -- vim.keymap.set('n', '<Leader>mt', MiniMap.toggle)

      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      local gitsigns = require 'gitsigns'
    end,
  },
  {
    'Isrothy/neominimap.nvim',
    dependencies = { 'lewis6991/gitsigns.nvim' },
    version = 'v3.*.*',
    enabled = true,
    lazy = false, -- NOTE: NO NEED to Lazy load
    -- Optional
    keys = {
      -- Global Minimap Controls
      { '<leader>nm', '<cmd>Neominimap toggle<cr>', desc = 'Toggle global minimap' },
      { '<leader>no', '<cmd>Neominimap on<cr>', desc = 'Enable global minimap' },
      { '<leader>nc', '<cmd>Neominimap off<cr>', desc = 'Disable global minimap' },
      { '<leader>nr', '<cmd>Neominimap refresh<cr>', desc = 'Refresh global minimap' },

      -- Window-Specific Minimap Controls
      { '<leader>nwt', '<cmd>Neominimap winToggle<cr>', desc = 'Toggle minimap for current window' },
      { '<leader>nwr', '<cmd>Neominimap winRefresh<cr>', desc = 'Refresh minimap for current window' },
      { '<leader>nwo', '<cmd>Neominimap winOn<cr>', desc = 'Enable minimap for current window' },
      { '<leader>nwc', '<cmd>Neominimap winOff<cr>', desc = 'Disable minimap for current window' },

      -- Tab-Specific Minimap Controls
      { '<leader>ntt', '<cmd>Neominimap tabToggle<cr>', desc = 'Toggle minimap for current tab' },
      { '<leader>ntr', '<cmd>Neominimap tabRefresh<cr>', desc = 'Refresh minimap for current tab' },
      { '<leader>nto', '<cmd>Neominimap tabOn<cr>', desc = 'Enable minimap for current tab' },
      { '<leader>ntc', '<cmd>Neominimap tabOff<cr>', desc = 'Disable minimap for current tab' },

      -- Buffer-Specific Minimap Controls
      { '<leader>nbt', '<cmd>Neominimap bufToggle<cr>', desc = 'Toggle minimap for current buffer' },
      { '<leader>nbr', '<cmd>Neominimap bufRefresh<cr>', desc = 'Refresh minimap for current buffer' },
      { '<leader>nbo', '<cmd>Neominimap bufOn<cr>', desc = 'Enable minimap for current buffer' },
      { '<leader>nbc', '<cmd>Neominimap bufOff<cr>', desc = 'Disable minimap for current buffer' },

      ---Focus Controls
      { '<leader>nf', '<cmd>Neominimap focus<cr>', desc = 'Focus on minimap' },
      { '<leader>nu', '<cmd>Neominimap unfocus<cr>', desc = 'Unfocus minimap' },
      { '<leader>ns', '<cmd>Neominimap toggleFocus<cr>', desc = 'Switch focus on minimap' },
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
  {
    'prettier/vim-prettier',
    config = function() end,
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
    config = function()
      require('typescript-tools').setup {
        -- spawn additional tsserver instance to calculate diagnostics on it
        separate_diagnostic_server = true,
        -- "change"|"insert_leave" determine when the client asks the server about diagnostic
        publish_diagnostic_on = 'insert_leave',
        -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
        -- "remove_unused_imports"|"organize_imports") -- or string "all"
        -- to include all supported code actions
        -- specify commands exposed as code_actions
        expose_as_code_action = {},
        -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
        -- not exists then standard path resolution strategy is applied
        tsserver_path = nil,
        -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
        -- (see 💅 `styled-components` support section)
        tsserver_plugins = {},
        -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
        -- memory limit in megabytes or "auto"(basically no limit)
        tsserver_max_memory = 'auto',
        -- described below
        tsserver_format_options = {},
        tsserver_file_preferences = {},
        -- locale of all tsserver messages, supported locales you can find here:
        -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
        tsserver_locale = 'en',
        -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
        complete_function_calls = false,
        include_completions_with_insert_text = true,
        -- CodeLens
        -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
        -- possible values: ("off"|"all"|"implementations_only"|"references_only")
        code_lens = 'off',
        -- by default code lenses are displayed on all referencable values and for some of you it can
        -- be too much this option reduce count of them by removing member references from lenses
        disable_member_code_lens = true,
        -- JSXCloseTag
        -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
        -- that maybe have a conflict if enable this feature. )
        jsx_close_tag = {
          enable = true,
          filetypes = { 'javascriptreact', 'typescriptreact' },
        },
      }
    end,
  },
  {
    'github/copilot.vim',
    config = function() end,
  },
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns',
}
