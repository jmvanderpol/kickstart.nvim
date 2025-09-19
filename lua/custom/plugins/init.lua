-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = {
      -- Completion provider plus extra snippets
      { 'ms-jpq/coq_nvim', branch = 'coq' },
      { 'ms-jpq/coq.artifacts', branch = 'artifacts' },
      { 'ms-jpq/coq.thirdparty', branch = '3p' },

      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { 'folke/neodev.nvim', opts = {} },
    },
    opts = {
      servers = {
        -- Ensure mason installs the server
        clangd = {
          keys = {
            { '<leader>ch', '<cmd>ClangdSwitchSourceHeader<cr>', desc = 'Switch Source/Header (C/C++)' },
          },
          root_dir = function(fname)
            return require('lspconfig.util').root_pattern(
              'Makefile',
              'configure.ac',
              'configure.in',
              'config.h.in',
              'meson.build',
              'meson_options.txt',
              'build.ninja'
            )(fname) or require('lspconfig.util').root_pattern('compile_commands.json', 'compile_flags.txt')(fname) or require('lspconfig.util').find_git_ancestor(
              fname
            )
          end,
          capabilities = {
            offsetEncoding = { 'utf-16' },
          },
          cmd = {
            'clangd',
            '--background-index',
            '--clang-tidy',
            '--header-insertion=iwyu',
            '--completion-style=detailed',
            '--function-arg-placeholders',
            '--fallback-style=llvm',
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
        neocmake = {},
      },
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        clangd = {},
        -- gopls = {},
        pyright = {},
        rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {},
        --

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
    setup = {
      clangd = function(_, opts)
        local clangd_ext_opts = LazyVim.opts 'clangd_extensions.nvim'
        require('clangd_extensions').setup(vim.tbl_deep_extend('force', clangd_ext_opts or {}, { server = opts }))
        return false
      end,
    },
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
  --{
  --  'maxmx03/fluoromachine.nvim',
  --  config = function()
  --    local fm = require 'fluoromachine'
  --    fm.setup {
  --      transparent = false,
  --      glow = true,
  --      theme = 'fluoromachine',
  --    }
  --    vim.cmd.colorscheme 'fluoromachine'
  --  end,
  --},
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function()
      require('catppuccin').setup {
        flavour = 'macchiato', -- latte, frappe, macchiato, mocha
        auto_integrations = true,
        color_overrides = {
          macchiato = {
            rosewater = '#e441a9',
            flamingo = '#e679da',
            pink = '#d8aef9',
            mauve = '#be94e4',
            red = '#fdf96f',
            maroon = '#f8df72',
            peach = '#fab770',
            yellow = '#faca64',
            green = '#93eebc',
            teal = '#93eebc',
            sky = '#7bf5f4',
            sapphire = '#6e76ae',
            blue = '#7bf5f4',
            lavender = '#6e76ae',
            text = '#b9b5d3',
            subtext1 = '#9e98bf',
            subtext0 = '#837ea7',
            overlay2 = '#6a648c',
            overlay1 = '#544f71',
            overlay0 = '#46415f',
            surface2 = '#3e3954',
            surface1 = '#332f46',
            surface0 = '#2c293d',
            base = '#262335',
            mantle = '#241b2f',
            crust = '#241b2f',
          },
        },
        dim_inactive = {
          enabled = true, -- dims the background color of inactive window
          shade = 'dark',
          percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        terminal_colors = true,
      }
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobject
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yin' - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }
      require('mini.animate').setup {
        scroll = {
          enable = false,
        },
      }
      require('mini.starter').setup()
      -- Minimal Fuzzy Search UI
      require('mini.fuzzy').setup()

      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Cursor Word highlighting
      require('mini.cursorword').setup()

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
    'nvim-zh/colorful-winsep.nvim',
    config = function()
      require('colorful-winsep').setup {
        -- choose between "single", "rounded", "bold" and "double".
        -- Or pass a table like this: { "─", "│", "┌", "┐", "└", "┘" },
        border = 'bold',
        excluded_ft = { 'Lazy', 'TelescopePrompt', 'mason' },
        highlight = nil, -- nil|string|function. See the docs's Highlights section
        animate = {
          enabled = 'shift', -- false to disable, or choose a option below (e.g. "shift") and set option for it if needed
          shift = {
            delta_time = 0.1,
            smooth_speed = 1,
            delay = 3,
          },
          progressive = {
            -- animation's speed for different direction
            vertical_delay = 20,
            horizontal_delay = 2,
          },
        },
        indicator_for_2wins = {
          -- only work when the total of windows is two
          position = 'center', -- false to disable or choose between "center", "start", "end" and "both"
          symbols = {
            -- the meaning of left, down ,up, right is the position of separator
            start_left = '󱞬',
            end_left = '󱞪',
            start_down = '󱞾',
            end_down = '󱟀',
            start_up = '󱞢',
            end_up = '󱞤',
            start_right = '󱞨',
            end_right = '󱞦',
          },
        },
      }
    end,
    event = { 'WinLeave' },
  },
  {
    'sindrets/winshift.nvim',
    config = function()
      require('winshift').setup {}
    end,
    keys = {
      -- Start WinMove mode:
      { '<leader>wM', '<cmd>WinShift<cr>', desc = 'WinShift' },
      -- Swap two windows:
      { '<leader>wX', '<cmd>WinShift swap<cr>', desc = 'WinShift Swap' },
      -- WinShift direct commands
      { '<leader>wH', '<cmd>WinShift left<cr>', desc = 'WinShift Left' },
      { '<leader>wJ', '<cmd>WinShift down<cr>', desc = 'WinShift Down' },
      { '<leader>wK', '<cmd>WinShift up<cr>', desc = 'WinShift Up' },
      { '<leader>wL', '<cmd>WinShift right<cr>', desc = 'WinShift Right' },
    },
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
  {
    'nyngwang/NeoTerm.lua',
    config = function()
      require('neo-term').setup {
        exclude_filetypes = { 'oil' },
        -- exclude_buftypes = {}, -- 'terminal' will always be added by NeoTerm.lua
        -- enabled by default!
        -- presets = {
        --   'vim-test',
        -- }
      }
      vim.keymap.set('n', '<M-Tab>', function()
        vim.cmd 'NeoTermToggle'
      end)
      vim.keymap.set('t', '<M-Tab>', function()
        vim.cmd 'NeoTermEnterNormal'
      end)
    end,
  },
  {
    'prettier/vim-prettier',
    config = function() end,
  },
  {
    'mason.nvim',
    opts = {
      ensure_installed = {
        'cmakelang',
        'cmakelint',
      },
    },
  },
  {
    'Civitasv/cmake-tools.nvim',
    lazy = true,
    init = function()
      local loaded = false
      local function check()
        local cwd = vim.uv.cwd()
        if vim.fn.filereadable(cwd .. '/CMakeLists.txt') == 1 then
          require('lazy').load { plugins = { 'cmake-tools.nvim' } }
          loaded = true
        end
      end
      check()
      vim.api.nvim_create_autocmd('DirChanged', {
        callback = function()
          if not loaded then
            check()
          end
        end,
      })
    end,
    opts = {},
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
    'epwalsh/obsidian.nvim',
    version = '*', -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = 'markdown',
    dependencies = {
      -- Required.
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp',
      'nvim-telescope/telescope.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      workspaces = {
        {
          name = 'Personal',
          path = '~/Library/Mobile Documents/iCloud~md~obsidian/Documents',
        },
        {
          name = 'Thorne',
          path = '~/Documents/Work/Thorne/Thorne',
        },
      },
    },
  },
  {
    'dlants/magenta.nvim',
    lazy = false, -- you could also bind to <leader>mt
    build = 'npm install --frozen-lockfile',
    opts = {
      profiles = {
        {
          name = 'copilot-gpt',
          provider = 'copilot',
          model = 'gpt-4.1',
          fastModel = 'gpt-4o', -- optional, defaults provided
        },
      },
      sidbarposition = 'right',
      picker = 'telescope',
      maxConcurrentSubAgents = 3,
      chimeVolume = 0.3,
      getFileAutoAllowGlobs = {
        'node_modules/*',
      },
      sidebarKeymaps = {
        normal = {
          ['<CR>'] = ':Megenta send<CR>',
        },
      },
    },
  },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {}
    end,
  },
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns',
}
