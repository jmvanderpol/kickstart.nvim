# jmvanderpol.nvim

A personal Neovim configuration with native LSP support, Tree-sitter, completion,
debugging, Git tools, and terminal-based AI integrations. Plugin definitions are
split by purpose under `lua/plugins/` and managed by
[Leanpack](https://github.com/ntk148v/leanpack.nvim) on top of Neovim's `vim.pack`.

The configuration originally grew out of Kickstart, but is now maintained
independently. The GitHub repository still uses the historical `kickstart.nvim`
name. These instructions describe the `leanpack` branch.

## Requirements

**Neovim 0.12.0 or newer is required.** Leanpack depends on the native `vim.pack`
API introduced in 0.12. Check the executable you actually launch:

```sh
nvim --version
```

Use the [official Neovim installation guide](https://github.com/neovim/neovim/blob/master/INSTALL.md)
to install a suitable build. A distribution's default package may be older than
this configuration supports.

| Dependency | Used for |
| --- | --- |
| Git | Plugin installation and updates, Git integrations |
| `curl`, `tar`, `unzip`, `gzip` | Tool and parser downloads and archive extraction |
| C compiler and `make` | Tree-sitter parsers and Telescope's native fzf extension |
| `ripgrep` (`rg`) | Telescope text search |
| Tree-sitter CLI | Parser installation; included in the default Mason tool list |
| Clipboard integration | System clipboard, enabled through `unnamedplus` |
| Nerd Font | Icons; `vim.g.have_nerd_font` defaults to `true` in `init.lua` |

The installed Tree-sitter plugin requires `tree-sitter-cli` 0.26.1 or newer.
Mason manages the CLI by default; it can also be supplied on `PATH`. Its
[requirements](https://github.com/nvim-treesitter/nvim-treesitter#requirements)
may change when the plugin is updated. If Mason installs the CLI on first launch,
restart Neovim afterward so parser installation can run.

Install the runtimes and build tools needed by your chosen servers: for example,
Node.js/npm for many web servers, Go for Go tooling, and a JDK for Java tooling.
Mason installs editor tools, but does not replace your project toolchains.
Mason itself is installed as a Neovim plugin; no separate Mason installation is
needed.

## Installation

Move an existing Neovim configuration aside before cloning. The commands below
assume the destination does not already exist.

### macOS, Linux, and WSL

```sh
git clone --branch https://github.com/jmvanderpol/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
cd "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
cp environment.example.json environment.json
```

### Windows PowerShell

```powershell
git clone --branch https://github.com/jmvanderpol/kickstart.nvim.git "$env:LOCALAPPDATA/nvim"
Set-Location "$env:LOCALAPPDATA/nvim"
Copy-Item environment.example.json environment.json
```

If you customize Neovim's configuration location, use the directory reported by
`:lua print(vim.fn.stdpath('config'))`. Some personal integrations below contain
macOS or Unix paths and need adjustment on other systems.

### First launch

Before starting Neovim, edit `environment.json` to select the language servers, tools,
and parsers you want. The example contains the full shared selection and can
install a substantial set of tools.

```sh
nvim
```

`init.lua` bootstraps Leanpack, which loads the specifications in `lua/plugins/`
and installs missing plugins. Mason installs selected language tools; Tree-sitter
installs selected parsers when its CLI is available. Allow downloads and build
hooks to finish before exiting. Use `:Leanpack` and `:Mason` to inspect progress,
then restart if newly installed executables are needed.

## Machine-specific languages

Shared language defaults live in `lua/config/languages.lua`. Copy the example
to create this machine's preferences (the local file is ignored by Git):

```sh
cp ~/.config/nvim/environment.example.json ~/.config/nvim/environment.json
```

Edit `environment.json`, then restart Neovim. For example:

```json
{
  "lsp_servers": ["lua_ls", "pyright", "gopls"],
  "mason_tools": ["stylua", "tree-sitter-cli"],
  "treesitter_parsers": ["lua", "luadoc", "python", "go", "markdown", "vimdoc"]
}
```

- `lsp_servers` uses **nvim-lspconfig server names**, such as `lua_ls` or `ts_ls`.
  Mason installs and automatically enables only the selected servers.
- `mason_tools` uses **Mason package names**, such as `stylua` (a formatter,
  not an LSP server). These tools are installed by mason-tool-installer.
- `treesitter_parsers` uses **Tree-sitter parser names**, such as `typescript`
  and `tsx`. Parsers install when `tree-sitter` is available; a C compiler is
  also required. Highlighting and indentation follow their mapped filetypes.

Each provided list replaces its shared default entirely. Omit a key to inherit
its default, or use `[]` to disable that category. With no local file, all shared
defaults apply. Removing an item does not uninstall its existing package/parser;
unselected Mason servers are no longer automatically enabled by this config.
Other plugins may manage their own language clients or parsers independently
(for example, typescript-tools).

For a file outside the configuration checkout, set an absolute path in your shell:

```sh
export NVIM_MACHINE_CONFIG="$HOME/.config/environment.json"
```

That file has the same JSON format. An explicitly configured missing file or an
invalid JSON structure reports a configuration error. The optional, Git-ignored
`lua/environment.lua` is still supported for legacy Lua settings and loads before
plugins; it is not needed for these language lists. Debug adapter selections in
`lua/plugins/debug.lua` remain separate.

## Configuration layout

| File or directory | Purpose |
| --- | --- |
| `init.lua` | Leader key, provider settings, Mason executable path, optional local settings, and Leanpack bootstrap |
| `lua/config/options.lua` | Editor options, clipboard, indentation, splits, and project-local configuration support |
| `lua/config/keymaps.lua` | General navigation and diagnostic mappings |
| `lua/config/autocommands.lua` | Yank highlighting, lint triggers, and other editor events |
| `lua/config/languages.lua` | Shared language server, tool, and parser defaults |
| `lua/config/machine.lua` | Local JSON loading and validation |
| `lua/config/lsp-config.lua` | Shared custom LSP server configurations |
| `lua/plugins/` | Active Leanpack plugin specifications |
| `nvim-pack-lock.json` | Native package lockfile recording plugin sources and revisions |
| `environment.example.json` | Tracked template for local language preferences |
| `lua/old-lazy-plugs/`, `lua/config/lazy.lua` | Historical configuration; not imported by the current startup path |

Add or modify plugin specifications in `lua/plugins/`. Most plugins default to
lazy loading; individual specifications use `lazy = false`, filetypes, commands,
events, or keys to control loading. Plugin keymaps usually live beside their
plugin's configuration.

## Included tools

| Area | Configuration |
| --- | --- |
| Languages | Mason, nvim-lspconfig, Fidget, Java/Spring Boot and TypeScript integrations |
| Syntax and editing | Tree-sitter, blink.cmp, snippets, automatic pairs, comments, and mini.nvim modules |
| Search and navigation | Telescope, Snacks explorer/picker/terminal, Barbar buffers, Edgy layouts, and WinShift |
| Git and diagnostics | Gitsigns, Diffview, Trouble, and TODO comments |
| Formatting and linting | Conform, nvim-lint, and vim-prettier |
| Debugging | nvim-dap, DAP UI, virtual text, Mason debug adapters, and Go support |
| Appearance | Catppuccin, icons, indentation guides, and Neominimap |
| Additional integrations | Codex, Claude Code, Dadbod database UI, Obsidian, Mastodon, and IRC |

Conform formats on save with a 500 ms timeout. Lua uses StyLua; JavaScript tries
`prettierd` then `prettier`. LSP formatting is a fallback except for C/C++.
Markdown linting uses `markdownlint`. Add these external executables to
`mason_tools` where available, or install them on `PATH`; the formatter and linter
configuration does not automatically install every executable it references.

### Personal integrations

Review these settings when moving the configuration to a new machine:

- **Obsidian:** `lua/plugins/misc.lua` points to a personal iCloud vault on macOS.
  Change its `workspaces` path before using the integration.
- **IRC:** `lua/plugins/chat.lua` reads `PICO_IRC_NICK`, `PICO_IRC_USER`, and
  `PICO_IRC_PASS` for the configured `irc.pico.sh` server. Set them in your shell
  or the optional local `lua/environment.lua`. The specification also declares
  an OpenSSL Lua rock; this is separate from the Mason language tool lists.
- **AI terminals:** the integrations in `lua/plugins/ai.lua` require their
  corresponding CLI installations and authentication. Codex notification paths
  currently use `/tmp/codex.nvim/notify.jsonl`.
- **Databases and social tools:** Dadbod needs the appropriate database clients
  and connection settings; Mastodon has its own account setup and SQLite dependency.

These integration settings are currently separate from the language JSON file.
Remove unwanted plugin specifications or set `enabled = false` in their specs.
Keep credentials out of tracked files.

## Everyday commands and keys

The leader key is **Space**. Press it and pause to see Which-key's available
mappings, or use `:Telescope keymaps` to search them.

| Key | Action |
| --- | --- |
| `<leader>sf` | Find files |
| `<leader>sg` | Search project text |
| `<leader><leader>` | Find open buffers |
| `<leader>/` | Search the current buffer |
| `<leader>sn` | Find configuration files |
| `<leader>ft` | Open the Snacks file explorer |
| `<leader>xx` | Toggle Trouble diagnostics |
| `<leader>e` | Show diagnostics at the cursor |
| `<C-h/j/k/l>` | Move between windows |
| `<Esc><Esc>` in a terminal | Return to normal mode |
| `<F5>` | Start or continue debugging |
| `<leader>db` | Toggle a breakpoint |
| `<leader>du` | Open the debugger UI |

## Maintenance and troubleshooting

| Command | Purpose |
| --- | --- |
| `:Leanpack` | Inspect installed plugins and loading status |
| `:Leanpack update` | Update plugins |
| `:Leanpack build telescope-fzf-native.nvim` | Rerun the native Telescope build hook |
| `:Leanpack clean` | Remove installed plugins no longer present in the specifications |
| `:Mason` | Inspect and manage language tools |
| `:MasonUpdate` | Refresh Mason's package registry |
| `:TSUpdate` | Update installed Tree-sitter parsers |
| `:ConformInfo` | Inspect available formatters and formatting status |
| `:checkhealth` | Inspect dependencies and plugin health |
| `:messages` | Review startup and runtime messages |

Review `nvim-pack-lock.json` changes after plugin updates. Parser versions need
to stay compatible with the installed Tree-sitter plugin; its build hook runs
`:TSUpdate` when the plugin is installed or updated. Language tools and parsers
are managed separately from the plugin lockfile.

If Mason reports an invalid `ensure_installed` entry, check that `lsp_servers`
contains nvim-lspconfig names and that formatters are under `mason_tools`. Keep
Mason configured with `lazy = false` in both LSP and debugger dependencies so
Leanpack initializes it consistently before the dependent plugins.

For missing syntax highlighting, check the selected parser list, the C compiler,
and `:lua print(vim.fn.executable('tree-sitter'))`. Restart after installing the
CLI. HTTP files use the standard `http` parser when selected; Kulala is no longer
part of this configuration.

To check Lua formatting from the repository root, with StyLua on `PATH`:

```sh
stylua --check init.lua lua/config lua/plugins
```

Formatting rules are in `.stylua.toml`. Some legacy files and GitHub templates
still contain Kickstart references; the supplied formatting workflow is currently
gated to the original upstream repository, so use the local check for this fork.
