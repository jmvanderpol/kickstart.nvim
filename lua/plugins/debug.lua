return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      -- Creates a beautiful debugger UI
      'rcarriga/nvim-dap-ui',

      -- Required dependency for nvim-dap-ui
      'nvim-neotest/nvim-nio',

      -- Installs the debug adapters for you
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',

      -- Add variable values when application is running
      'theHamsta/nvim-dap-virtual-text',

      -- Add your own debuggers here
      'leoluz/nvim-dap-go',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'
      local dap_virt_text = require 'nvim-dap-virtual-text'

      dap_virt_text.setup()

      require('mason-nvim-dap').setup {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
          'chrome',
          'cppdbg',
          'delve',
          'firefox',
          'javadbg',
          'js',
          'kotin',
          'node2',
          'python',
        },

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {
          function(config)
            -- All sources with no handler get passed here
            -- Keep original functionality
            require('mason-nvim-dap').default_setup(config)
          end,
          codelldb = function(config)
            config.adapters = {
              {
                type = 'codelldb',
                request = 'launch',
                name = 'Launch file',
                program = function()
                  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
              },
              {
                type = 'codelldb',
                request = 'attach',
                name = 'Attach to process',
                pid = require('dap.utils').pick_process,
                cwd = '${workspaceFolder}',
              },
            }
            require('mason-nvim-dap').default_setup(config) -- don't forget this!
          end,
          cpp = function(config)
            config.adapters = {
              {
                name = 'Launch file',
                type = 'cppdbg',
                request = 'launch',
                program = function()
                  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopAtEntry = false,
                MIMode = 'lldb',
              },
              {
                name = 'Attach to lldbserver :1234',
                type = 'cppdbg',
                request = 'launch',
                MIMode = 'lldb',
                miDebuggerServerAddress = 'localhost:1234',
                miDebuggerPath = '/usr/bin/lldb',
                cwd = '${workspaceFolder}',
                program = function()
                  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
              },
            }
            require('mason-nvim-dap').default_setup(config) -- don't forget this!
          end,
          python = function(config)
            config.adapters = {
              type = 'executable',
              command = '/usr/bin/python3',
              args = {
                '-m',
                'debugpy.adapter',
              },
            }
            require('mason-nvim-dap').default_setup(config) -- don't forget this!
          end,
          java = function(config)
            config.adapters = {
              type = 'java',
              request = 'attach',
              name = 'Debug (Attach) - Remote',
              hostName = '127.0.0.1',
              port = 5005,
            }
            require('mason-nvim-dap').default_setup(config) -- don't forget this!
          end,
          javascript = function(config)
            config.adapters = {
              {
                name = 'Launch file',
                type = 'pwa-node',
                request = 'launch',
                program = '${file}',
                cwd = '${workspaceFolder}',
                skipFiles = {
                  '<node_internals>/**',
                  'node_modules/**',
                },
                resolveSourceMapLocations = {
                  '${workspaceFolder}/**',
                  '!**/node_modules/**',
                },
              },
              {
                name = 'Launch',
                type = 'node2',
                request = 'launch',
                program = '${file}',
                cwd = vim.fn.getcwd(),
                sourceMaps = true,
                protocol = 'inspector',
                console = 'NeoTerm',
                skipFiles = {
                  '<node_internals>/**',
                  'node_modules/**',
                },
                resolveSourceMapLocations = {
                  '${workspaceFolder}/**',
                  '!**/node_modules/**',
                },
              },
              {
                -- For this to work you need to make sure the node process is started with the `--inspect` flag.
                name = 'Attach to process',
                type = 'node2',
                request = 'attach',
                processId = require('dap.utils').pick_process,
                skipFiles = {
                  '<node_internals>/**',
                  'node_modules/**',
                },
                resolveSourceMapLocations = {
                  '${workspaceFolder}/**',
                  '!**/node_modules/**',
                },
              },
            }
            require('mason-nvim-dap').default_setup(config) -- don't forget this!
          end,
          javascriptreact = function(config)
            config.adapters = {
              {
                name = 'Launch file',
                type = 'pwa-node',
                request = 'launch',
                program = '${file}',
                cwd = '${workspaceFolder}',
                skipFiles = {
                  '<node_internals>/**',
                  'node_modules/**',
                },
                resolveSourceMapLocations = {
                  '${workspaceFolder}/**',
                  '!**/node_modules/**',
                },
              },
              {
                name = 'Launch',
                type = 'node2',
                request = 'launch',
                program = '${file}',
                cwd = vim.fn.getcwd(),
                sourceMaps = true,
                protocol = 'inspector',
                console = 'integratedTerminal',
                skipFiles = {
                  '<node_internals>/**',
                  'node_modules/**',
                },
                resolveSourceMapLocations = {
                  '${workspaceFolder}/**',
                  '!**/node_modules/**',
                },
              },
              {
                -- For this to work you need to make sure the node process is started with the `--inspect` flag.
                name = 'Attach to process',
                type = 'node2',
                request = 'attach',
                processId = require('dap.utils').pick_process,
                skipFiles = {
                  '<node_internals>/**',
                  'node_modules/**',
                },
                resolveSourceMapLocations = {
                  '${workspaceFolder}/**',
                  '!**/node_modules/**',
                },
              },
            }
            require('mason-nvim-dap').default_setup(config) -- don't forget this!
          end,
          kotlin = function(config)
            config.adapters = {
              {
                type = 'kotlin',
                request = 'launch',
                name = 'This file',
                -- may differ, when in doubt, whatever your project structure may be,
                -- it has to correspond to the class file located at `build/classes/`
                -- and of course you have to build before you debug
                mainClass = function()
                  local root = vim.fs.find('src', { path = vim.uv.cwd(), upward = true, stop = vim.env.HOME })[1] or ''
                  local fname = vim.api.nvim_buf_get_name(0)
                  -- src/main/kotlin/websearch/Main.kt -> websearch.MainKt
                  return fname:gsub(root, ''):gsub('main/kotlin/', ''):gsub('.kt', 'Kt'):gsub('/', '.'):sub(2, -1)
                end,
                projectRoot = '${workspaceFolder}',
                jsonLogFile = '',
                enableJsonLogging = false,
              },
              {
                -- Use this for unit tests
                -- First, run
                -- ./gradlew --info cleanTest test --debug-jvm
                -- then attach the debugger to it
                type = 'kotlin',
                request = 'attach',
                name = 'Attach to debugging session',
                port = 5005,
                args = {},
                projectRoot = vim.fn.getcwd,
                hostName = 'localhost',
                timeout = 2000,
              },
              require('mason-nvim-dap').default_setup(config), -- don't forget this!
            }
          end,
          typescript = function(config)
            config.adapters = {
              {
                type = 'pwa-node',
                request = 'launch',
                name = 'Launch file',
                program = '${file}',
                cwd = '${workspaceFolder}',
                sourceMaps = true,
                runtimeExecutable = 'ts-node',
                skipFiles = {
                  '<node_internals>/**',
                  'node_modules/**',
                },
                resolveSourceMapLocations = {
                  '${workspaceFolder}/**',
                  '!**/node_modules/**',
                },
              },
              {
                type = 'pwa-node',
                request = 'attach',
                name = 'Attach',
                processId = require('dap.utils').pick_process,
                cwd = '${workspaceFolder}',
                sourceMaps = true,
                runtimeExecutable = 'ts-node',
                skipFiles = {
                  '<node_internals>/**',
                  'node_modules/**',
                },
                resolveSourceMapLocations = {
                  '${workspaceFolder}/**',
                  '!**/node_modules/**',
                },
              },
            }
            require('mason-nvim-dap').default_setup(config) -- don't forget this!
          end,
          typescriptreact = function(config)
            config.adapters = {
              {
                type = 'pwa-node',
                request = 'launch',
                name = 'Launch file',
                program = '${file}',
                cwd = '${workspaceFolder}',
                sourceMaps = true,
                runtimeExecutable = 'tsx',
                skipFiles = {
                  '<node_internals>/**',
                  'node_modules/**',
                },
                resolveSourceMapLocations = {
                  '${workspaceFolder}/**',
                  '!**/node_modules/**',
                },
              },
              {
                type = 'pwa-node',
                request = 'attach',
                name = 'Attach',
                processId = require('dap.utils').pick_process,
                cwd = '${workspaceFolder}',
                sourceMaps = true,
                runtimeExecutable = 'tsx',
                skipFiles = {
                  '<node_internals>/**',
                  'node_modules/**',
                },
                resolveSourceMapLocations = {
                  '${workspaceFolder}/**',
                  '!**/node_modules/**',
                },
              },
            }
            require('mason-nvim-dap').default_setup(config) -- don't forget this!
          end,
        },
      }

      -- Basic debugging keymaps, feel free to change to your liking!
      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { desc = 'Debug: Set Breakpoint' })

      -- Dap UI setup
      -- For more information, see |:help nvim-dap-ui|
      dapui.setup {
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- Install golang specific config
      require('dap-go').setup {
        delve = {
          -- On Windows delve must be run attached or it crashes.
          -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
          detached = vim.fn.has 'win32' == 0,
        },
      }
      require('javadb').setup {}
    end,
    keys = {
      {
        '<leader>du',
        function()
          require('dapui').open()
        end,
        desc = '[D]ebug: Open DAP-[U]I',
      },
      {
        '<leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = '[D]ebug: Toggle [b]reakpoint',
      },

      {
        '<leader>dc',
        function()
          require('dap').continue()
        end,
        desc = '[D]ebug: [c]ontinue',
      },

      {
        '<leader>dC',
        function()
          require('dap').run_to_cursor()
        end,
        desc = '[D]ebug: Run to [C]ursor',
      },

      {
        '<leader>dT',
        function()
          require('dap').terminate()
        end,
        desc = '[D]ebug: [T]erminate',
      },
    },
  },
  {},
}
