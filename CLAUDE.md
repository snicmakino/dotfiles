# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration using lazy.nvim as the plugin manager. The configuration supports Lua, TypeScript/JavaScript, and Kotlin development with LSP integration.

## Architecture

```
~/.config/nvim/
├── init.lua              # Entry point: loads lazy.nvim, then requires config modules
├── lua/
│   ├── plugins.lua       # Plugin definitions (lazy.nvim spec format)
│   └── config/
│       ├── options.lua   # Vim options (line numbers, tabs, search, etc.)
│       ├── keymaps.lua   # Key mappings using which-key
│       └── lsp.lua       # LSP servers and nvim-cmp completion setup
```

**Load order**: `init.lua` -> `config.options` -> `lazy.setup("plugins")` -> `config.keymaps` -> `config.lsp`

## Key Conventions

- **Leader key**: Space
- **Local leader**: Comma
- Plugin specs go in `lua/plugins.lua` as a single return table
- LSP servers are managed via Mason; configured servers: `lua_ls`, `ts_ls`, `kotlin_language_server`
- Formatters via conform.nvim: stylua (Lua), ktlint (Kotlin), prettier (JS/TS/HTML/CSS)
- Format on save is enabled by default

## Main Keymaps (Space + key)

| Key | Action |
|-----|--------|
| `e` | Toggle file tree |
| `ff/fg/fb` | Telescope: files/grep/buffers |
| `F` | Format buffer |
| `gg` | LazyGit |
| `xx/xd` | Trouble: all diagnostics/buffer |
| `Tn/Tf/Tl/Ta` | Test: nearest/file/last/all |
| `tt/th/tv/tf` | Terminal: toggle/horizontal/vertical/float |
| `ac/af` | Claude Code: toggle/focus |
| `rr` | Run HTTP request (kulala) |
| `gd/K/rn/ca` | LSP: definition/hover/rename/code action |

## Plugin Notes

- **claudecode.nvim**: Integrated for AI assistance (`<leader>a` group)
- **vim-test**: Configured for Gradle (Kotlin/Java) and Jest (JS/TS)
- **kulala.nvim**: REST client for `.http` files (Enter to run request)
- **Telescope**: Uses `fdfind` for file search, `rg` for grep
