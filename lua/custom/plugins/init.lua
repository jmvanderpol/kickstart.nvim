-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      local use_icons, devicons = pcall(require, 'nvim-web-devicons')
      local tree = require 'nvim-tree'
      local function on_attach(bufnr)
        local api = require 'nvim-tree.api'

        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set('n', '<Leader>O', '', { buffer = bufnr })
        vim.keymap.del('n', '<Leader>O', { buffer = bufnr })
        vim.keymap.set('n', '<Leader>D', '', { buffer = bufnr })
        vim.keymap.del('n', '<Leader>D', { buffer = bufnr })
        vim.keymap.set('n', '<Leader>E', '', { buffer = bufnr })
        vim.keymap.del('n', '<Leader>E', { buffer = bufnr })

        vim.keymap.set('n', '<Leader>A', api.tree.expand_all, opts 'Expand All')
        vim.keymap.set('n', '<Leader>?', api.tree.toggle_help, opts 'Help')
        vim.keymap.set('n', '<Leader>C', api.tree.change_root_to_node, opts 'CD')
        vim.keymap.set('n', '<Leader>P', function()
          local node = api.tree.get_node_under_cursor()
          print(node.absolute_path)
        end, opts 'Print Node Path')

        vim.keymap.set('n', '<Leader>Z', api.node.run.system, opts 'Run System')
      end

      tree.setup {
        on_attach = on_attach,
        auto_reload_on_write = false,
        disable_netrw = false,
        hijack_cursor = false,
        hijack_netrw = true,
        hijack_unnamed_buffer_when_opening = false,
        sort_by = 'name',
        root_dirs = {},
        prefer_startup_root = false,
        sync_root_with_cwd = true,
        reload_on_bufenter = false,
        respect_buf_cwd = false,
        select_prompts = false,
        view = {
          adaptive_size = false,
          centralize_selection = true,
          width = 30,
          side = 'left',
          preserve_window_proportions = false,
          number = false,
          relativenumber = false,
          signcolumn = 'yes',
          float = {
            enable = false,
            quit_on_focus_loss = true,
            open_win_config = {
              relative = 'editor',
              border = 'rounded',
              width = 30,
              height = 30,
              row = 1,
              col = 1,
            },
          },
        },
        renderer = {
          add_trailing = false,
          group_empty = false,
          highlight_git = true,
          full_name = false,
          highlight_opened_files = 'none',
          root_folder_label = ':t',
          indent_width = 2,
          indent_markers = {
            enable = true,
            inline_arrows = true,
            icons = {
              corner = '└',
              edge = '│',
              item = '│',
              none = ' ',
            },
          },
          icons = {
            webdev_colors = vim.g.have_nerd_font,
            git_placement = 'before',
            padding = ' ',
            symlink_arrow = ' ➛ ',
            show = {
              file = vim.g.have_nerd_font,
              folder = vim.g.have_nerd_font,
              folder_arrow = vim.g.have_nerd_font,
              git = vim.g.have_nerd_font,
            },
            glyphs = {
              default = '󰈔',
              symlink = '󰈤',
              bookmark = '󰃀',
              folder = {
                arrow_closed = '󰅂',
                arrow_open = '󰅀',
                default = '󰉋',
                open = '󰉓',
                empty = '󰉖',
                empty_open = '󰉕',
                symlink = '󰉒',
                symlink_open = '󰉒',
              },
              git = {
                unstaged = 'U',
                staged = 'S',
                unmerged = 'M',
                renamed = 'R',
                untracked = 'U',
                deleted = 'D',
                ignored = '◌',
              },
            },
          },
          special_files = { 'Cargo.toml', 'Makefile', 'README.md', 'readme.md' },
          symlink_destination = true,
        },
        hijack_directories = {
          enable = false,
          auto_open = true,
        },
        update_focused_file = {
          enable = true,
          debounce_delay = 15,
          update_root = true,
          ignore_list = {},
        },
        diagnostics = {
          enable = false,
          show_on_dirs = false,
          show_on_open_dirs = true,
          debounce_delay = 50,
          severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
          },
          icons = {
            hint = '󰁚',
            info = '󰋽',
            warning = '󰀪',
            error = '󰀩',
          },
        },
        filters = {
          dotfiles = false,
          git_clean = false,
          no_buffer = false,
          custom = { 'node_modules', '\\.cache' },
          exclude = {},
        },
        filesystem_watchers = {
          enable = true,
          debounce_delay = 50,
          ignore_dirs = {},
        },
        git = {
          enable = true,
          ignore = false,
          show_on_dirs = true,
          show_on_open_dirs = true,
          timeout = 200,
        },
        actions = {
          use_system_clipboard = true,
          change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = false,
          },
          expand_all = {
            max_folder_discovery = 300,
            exclude = {},
          },
          file_popup = {
            open_win_config = {
              col = 1,
              row = 1,
              relative = 'cursor',
              border = 'shadow',
              style = 'minimal',
            },
          },
          open_file = {
            quit_on_open = false,
            resize_window = false,
            window_picker = {
              enable = true,
              picker = 'default',
              chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',
              exclude = {
                filetype = { 'notify', 'lazy', 'qf', 'diff', 'fugitive', 'fugitiveblame' },
                buftype = { 'nofile', 'terminal', 'help' },
              },
            },
          },
          remove_file = {
            close_window = true,
          },
        },
        trash = {
          cmd = 'trash',
          require_confirm = true,
        },
        live_filter = {
          prefix = '[FILTER]: ',
          always_show_folders = true,
        },
        tab = {
          sync = {
            open = false,
            close = false,
            ignore = {},
          },
        },
        notify = {
          threshold = vim.log.levels.INFO,
        },
        log = {
          enable = false,
          truncate = false,
          types = {
            all = false,
            config = false,
            copy_paste = false,
            dev = false,
            diagnostics = false,
            git = false,
            profile = false,
            watcher = false,
          },
        },
        system_open = {
          cmd = nil,
          args = {},
        },
      }

      local function open_nvim_tree_on_launch(data)
        -- buffer is a real file on the disk
        local real_file = vim.fn.filereadable(data.file) == 1
        -- buffer is a [No Name]
        local no_name = data.file == '' and vim.bo[data.buf].buftype == ''

        if not real_file and not no_name then
          return
        end

        -- open the tree, find the file but don't focus it
        require('nvim-tree.api').tree.toggle { focus = false, find_file = true }
      end

      function NvimTreeCloseIfLast()
        local only_one = vim.fn.tabpagenr '$' == 1 and vim.fn.winnr '$' == 1
        local is_visible = require('nvim-tree.view').is_visible()

        if only_one and is_visible then
          vim.cmd 'quit'
        end
      end

      vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree_on_launch })
      vim.cmd 'autocmd BufEnter * lua NvimTreeCloseIfLast()'
    end,
  },
  {
    'maxmx03/fluoromachine.nvim',
    config = function()
      local fm = require 'fluoromachine'
      fm.setup {
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
      local minimap = require 'mini.map'
      minimap.setup {
        symbols = {
          encode = minimap.gen_encode_symbols.shade '1x2',
        },
      }

      vim.keymap.set('n', '<Leader>mc', MiniMap.close)
      vim.keymap.set('n', '<Leader>mf', MiniMap.toggle_focus)
      vim.keymap.set('n', '<Leader>mo', MiniMap.open)
      vim.keymap.set('n', '<Leader>mr', MiniMap.refresh)
      vim.keymap.set('n', '<Leader>ms', MiniMap.toggle_side)
      vim.keymap.set('n', '<Leader>mt', MiniMap.toggle)

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
}
