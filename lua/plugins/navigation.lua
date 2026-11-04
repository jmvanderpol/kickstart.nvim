return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      bufdelete = { enabled = true },
      dashboard = { enabled = true },
      explorer = {
        enabled = true,
        replace_netrw = true,
        trash = true,
      },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000, -- default timeout in ms
        width = { min = 40, max = 0.4 },
        height = { min = 1, max = 0.6 },
        -- editor margin to keep free. tabline and statusline are taken into account automatically
        margin = { top = 0, right = 1, bottom = 0 },
        padding = true, -- add 1 cell of left/right padding to the notification window
        gap = 0, -- gap between notifications
        sort = { 'level', 'added' }, -- sort by level and time
        -- minimum log level to display. TRACE is the lowest
        -- all notifications are stored in history
        level = vim.log.levels.TRACE,
        icons = {
          error = ' ',
          warn = ' ',
          info = ' ',
          debug = ' ',
          trace = ' ',
        },
        keep = function(notif)
          return vim.fn.getcmdpos() > 0
        end,
        ---@type snacks.notifier.style
        style = 'compact',
        top_down = true, -- place notifications from top to bottom
        date_format = '%R', -- time format for notifications
        -- format for footer when more lines are available
        -- `%d` is replaced with the number of lines.
        -- only works for styles with a border
        ---@type string|boolean
        more_format = ' ↓ %d lines ',
        refresh = 50, -- refresh at most every 50ms
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      terminal = {
        enabled = true,
        win = { style = 'terminal' },
      },
      words = { enabled = true },
    },
    keys = {
      -- Snacks File Explorer Key Bindings
      { '<leader>ft', '<cmd>lua Snacks.explorer.reveal()<cr>', desc = '[F]ile Explorer: Open explorer pane.' },

      -- Snacks Terminal Key Bindings
      { '<leader>tn', '<cmd>lua Snacks.ternimal.open()<cr>', desc = '[T]erminal: Open [n]ew terminal window.' },
      { '<leader>tn', '<cmd>lua Snacks.terminal.toggle()<cr>', desc = '[T]erminal: [T]oggle terminal window.' },
    },
  },
  {
    'folke/edgy.nvim',
    event = 'VeryLazy',
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = 'screen'
    end,
    opts = {
      left = {}, ---@type (Edgy.View.Opts|string)[]
      bottom = {
        {
          ft = 'snacks_terminal',
          title = 'Terminal',
        },
        { ft = 'qf', title = 'QuickFix' },
        {
          ft = 'help',
          size = {},
          -- only show help buffers
          filter = function(buf)
            return vim.bo[buf].buftype == 'help'
          end,
        },
        {
          ft = 'spectre_panel',
        },
      }, ---@type (Edgy.View.Opts|string)[]
      right = {
        {
          ft = 'touble',
          title = 'Trouble',
        },
      }, ---@type (Edgy.View.Opts|string)[]
      top = {}, ---@type (Edgy.View.Opts|string)[]

      ---@type table<Edgy.Pos, {size:integer | fun():integer, wo?:vim.wo}>
      options = {
        left = { size = 20 },
        right = { size = 20 },
        bottom = { size = 20 },
        top = { size = 10 },
      },
      -- edgebar animations
      animate = {
        enabled = false, -- animation seems to cause layout issues
        fps = 100, -- frames per second
        cps = 120, -- cells per second
      },
      exit_when_last = true,
    },
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
      buffer_number = true,
      focus_on_close = true,
      insert_at_end = true,
      highlight_visible = true,
      sidebar_filetypes = {
        snacks_picker_list = true,
      },
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  },
}
