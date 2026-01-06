return {
  {
    -- src: https://github.com/microsoft/azure-pipelines-language-server
    ---@type vim.lsp.Config
    -- `azure-pipelines-ls` can be installed via `npm`:
    cmd = { 'azure-pipelines-language-server', '--stdio' },
    filetypes = { 'yaml' },
    root_markers = { 'azure-pipelines.yml' },
    settings = {
      --- By default `azure-pipelines-ls` will only work in files named `azure-pipelines.yml`,
      --- this can be changed by providing additional settings like so:
      yaml = {
        schemas = {
          ['https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json'] = {
            '/azure-pipelines*.yml',
          },
        },
      },
    },
  },
  {
    -- src: https://github.com/vuejs/language-tools/tree/master/packages/language-server
    -- The Vue language server works in "hybrid mode" that exclusively manages the CSS/HTML sections.
    -- You need the `vtsls` server with the `@vue/typescript-plugin` plugin to support TypeScript in `.vue` files.
    -- See `vtsls` section and https://github.com/vuejs/language-tools/wiki/Neovim for more information.
    ---@type vim.lsp.Config
    cmd = { 'vue-language-server', '--stdio' },
    filetypes = { 'vue' },
    root_markers = { 'package.json' },
    on_init = function(client)
      local retries = 0

      ---@param _ lsp.ResponseError
      ---@param result any
      ---@param context lsp.HandlerContext
      local function typescriptHandler(_, result, context)
        local ts_client = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'ts_ls' })[1]
          or vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })[1]
          or vim.lsp.get_clients({ bufnr = context.bufnr, name = 'typescript-tools' })[1]

        if not ts_client then
          -- there can sometimes be a short delay until `ts_ls`/`vtsls` are attached so we retry for a few times until it is ready
          if retries <= 10 then
            retries = retries + 1
            vim.defer_fn(function()
              typescriptHandler(_, result, context)
            end, 100)
          else
            vim.notify('Could not find `ts_ls`, `vtsls`, or `typescript-tools` lsp client required by `vue_ls`.', vim.log.levels.ERROR)
          end
          return
        end

        local param = unpack(result)
        local id, command, payload = unpack(param)
        ts_client:exec_cmd({
          title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
          command = 'typescript.tsserverRequest',
          arguments = {
            command,
            payload,
          },
        }, { bufnr = context.bufnr }, function(_, r)
          local response_data = { { id, r and r.body } }
          ---@diagnostic disable-next-line: param-type-mismatch
          client:notify('tsserver/response', response_data)
        end)
      end

      client.handlers['tsserver/request'] = typescriptHandler
    end,
  },
  {},
  {
    cmd = { 'vtsls', '--stdio' },
    init_options = {
      hostInfo = 'neovim',
    },
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = {
          maxInlayHintLength = 30,
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = 'always' },
        suggest = {
          completeFunctionCalls = true,
        },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = 'literals' },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
      },
    },
    keys = {},
    root_dir = function(bufnr, on_dir)
      -- The project root is where the LSP can be started from
      -- As stated in the documentation above, this LSP supports monorepos and simple projects.
      -- We select then from the project root, which is identified by the presence of a package
      -- manager lock file.
      local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
      -- Give the root markers equal priority by wrapping them in a table
      root_markers = vim.fn.has 'nvim-0.11.3' == 1 and { root_markers, { '.git' } } or vim.list_extend(root_markers, { '.git' })

      -- exclude deno
      if vim.fs.root(bufnr, { 'deno.json', 'deno.lock' }) then
        return
      end

      -- We fallback to the current working directory if no project root is found
      local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

      on_dir(project_root)
    end,
  },
  {
    -- src: https://github.com/hashicorp/terraform-ls
    ---@type vim.lsp.Config
    cmd = { 'terraform-ls', 'serve' },
    filetypes = { 'terraform', 'terraform-vars' },
    root_markers = { '.terraform', '.git' },
  },
  {
    -- src: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/ty.lua
    ---@type vim.lsp.Config
    cmd = { 'ty', 'server' },
    filetypes = { 'python' },
    root_markers = { 'ty.toml', 'pyproject.toml', '.git' },
  },
  {
    -- src: https://github.com/g-plane/wasm-language-tools
    -- WebAssembly Language Tools aims to provide and improve the editing experience of WebAssembly Text Format.
    -- It also provides an out-of-the-box formatter (a.k.a. pretty printer) for WebAssembly Text Format.
    ---@type vim.lsp.Config
    cmd = { 'wat_server' },
    filetypes = { 'wat' },
  },
  vim.lsp.enable { 'azure-pipelines-language-server', 'vue-language-server', 'vtsls', 'terraform-ls', 'ty', 'wat_server' },
}
