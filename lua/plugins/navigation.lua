return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',
        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
    end,
    keys = {
      {
        '<leader>s',
        group = 'Telescope',
        desc = 'Telescope Search:',
      },
      {
        'leader>sf',
        '<cmd>Telescope find_files<cr>',
        desc = '[S]earch [F]iles',
        mode = { 'n', 'v' },
      },
      -- See `:help telescope.builtin`
      {
        '<leader>sh',
        '<cmd>Telescope help_tags<cr>',
        desc = '[S]earch [H]elp',
      },
      {
        '<leader>sk',
        '<cmd>Telescope keymaps<cr>',
        desc = '[S]earch [K]eymaps',
      },
      {
        '<leader>sf',
        '<cmd>Telescope find_files<cr>',
        desc = '[S]earch [F]iles',
      },
      {
        '<leader>ss',
        '<cmd>Telescope builtin<cr>',
        desc = '[S]earch [S]elect Telescope',
      },
      {
        '<leader>sw',
        '<cmd>Telescope grep_string<cr>',
        mode = { 'n', 'v' },
        desc = '[S]earch current [W]ord',
      },
      {
        '<leader>sg',
        '<cmd>Telescope live_grep<cr>',
        desc = '[S]earch by [G]rep',
      },
      {
        '<leader>sd',
        '<cmd>Telescope order_by_diagnostics<cr>',
        desc = '[S]earch [D]iagnostics',
      },
      {
        '<leader>sr',
        '<cmd>Telescope resume<cr>',
        desc = '[S]earch [R]esume',
      },
      {
        '<leader>s.',
        '<cmd>Telescope open_files_do_not_replace_types<cr>',
        desc = '[S]earch Recent Files ("." for repeat)',
      },
      {
        '<leader><leader>',
        '<cmd>Telescope buffers<cr>',
        desc = '[ ] Find existing buffers',
      },

      -- Slightly advanced example of overriding default behavior and theme
      {
        '<leader>/',
        function()
          -- You can pass additional configuration to Telescope to change the theme, layout, etc.
          require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end,
        desc = '[/] Fuzzily search in current buffer',
      },

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      {
        '<leader>s/',
        function()
          require('telescope.builtin').live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end,
        desc = '[S]earch [/] in Open Files',
      },

      -- Shortcut for searching your Neovim configuration files
      {
        '<leader>sn',
        function()
          require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = '[S]earch [N]eovim files',
      },
    },
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    event = 'VimEnter',
    branch = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      'folke/snacks.nvim',
      '3rd/image.nvim',
    },
    cmd = 'Neotree',
    init = function()
      vim.api.nvim_create_autocmd('BufEnter', {
        -- make a group to be able to delete it later
        group = vim.api.nvim_create_augroup('NeoTreeInit', { clear = true }),
        desc = 'Start Neo-tree with directory',
        once = true,
        callback = function()
          if package.loaded['neo-tree'] then
            return
          else
            local stats = vim.uv.fs_stat(vim.fn.argv(0))
            if stats and stats.type == 'directory' then
              require 'neo-tree'
            end
          end
        end,
      })
    end,
    keys = {
      {
        '<leader>ff',
        function()
          require('neo-tree.command').execute { toggle = true, dir = vim.uv.cwd() }
        end,
        desc = 'NeoTree: Explore (cwd)',
      },
      {
        '<leader>fg',
        function()
          require('neo-tree.command').execute { source = 'git_status', toggle = true }
        end,
        desc = 'NeotTree: Explore Git',
      },
      {
        '<leader>fb',
        function()
          require('neo-tree.command').execute { source = 'buffers', toggle = true }
        end,
        desc = 'NeoTree: Explore Buffers',
      },
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
        bind_to_cwd = true, -- creates a 2-way binding between vim's cwd and neo-tree's root
        cwd_target = {
          sidebar = 'tab', -- sidebar is when position = left or right
          current = 'window', -- current is when position = current
        },
        open_files_do_not_replace_types = {
          'terminal',
          'quickfix',
        },
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
          position = 'left',
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
            '.gitignored',
          },
          always_show_by_pattern = { -- uses glob style patterns
            '.env*',
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
    'nvim-zh/colorful-winsep.nvim',
    event = { 'WinLeave' },
    opt = {
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
        position = 'both', -- false to disable or choose between "center", "start", "end" and "both"
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
    },
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
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      animation = true,
      focus_on_close = true,
      insert_at_end = true,
      highlight_visible = true,
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  },
}
