# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository for managing development environment configurations across different tools and applications. The repository uses symlink-based management for easy synchronization and version control.

## Repository Structure

```
~/dotfiles/
├── nvim/              # Neovim configuration
│   ├── init.lua       # Entry point
│   ├── lazy-lock.json # Plugin lockfile
│   └── lua/           # Lua configuration modules
├── wezterm/           # WezTerm terminal configuration (Windows-based)
├── install.sh         # Symlink management script
└── README.md          # User documentation
```

**Symlink mappings:**
- `~/.config/nvim` → `~/dotfiles/nvim`

## Installation

Run the installation script to create symlinks:
```bash
cd ~/dotfiles
./install.sh
```

The script supports several options:
- `-f`: Force mode (skip confirmations)
- `-n`: Dry-run mode (show what would be done)
- `-v`: Verbose output
- `-h`: Help message

## Key Conventions

### File Management
- Each application has its own subdirectory (e.g., `nvim/`, `wezterm/`)
- Application-specific documentation goes in `<app>/CLAUDE.md`
- Use `install.sh` for automated symlink management
- Backup existing configs with timestamps before replacing

### Git Workflow
- Use `git mv` when relocating tracked files to preserve history
- Keep `.gitignore` at both root and application levels
- Track lockfiles (e.g., `lazy-lock.json`) for reproducibility
- Use `.placeholder` files for empty directories that need to be tracked

### Cross-Platform Considerations
- This repository is primarily used on WSL2 (Linux)
- WezTerm runs on Windows side, requiring special handling
- Document platform-specific setup steps in README.md

## Application-Specific Guides

### Neovim
See [nvim/CLAUDE.md](nvim/CLAUDE.md) for detailed Neovim configuration documentation including:
- Plugin management with lazy.nvim
- LSP configuration
- Key mappings
- Testing setup

### WezTerm
WezTerm configuration is stored in `wezterm/` but runs on Windows. See README.md for manual setup instructions due to WSL/Windows filesystem boundary.

## Development Guidelines

### Adding New Configurations

When adding a new tool configuration:

1. Create a new subdirectory: `mkdir <tool-name>`
2. Add configuration files to the subdirectory
3. Update `install.sh` to include the new symlink mapping
4. Document the tool in README.md
5. Create `<tool-name>/CLAUDE.md` if configuration is complex

### Testing Changes

Before committing:
1. Run `./install.sh -n` to verify dry-run output
2. Test actual installation in a safe environment
3. Verify the application works with symlinked config
4. Check `git status` for unintended changes

### Backup Strategy

The `install.sh` script automatically:
- Detects existing configurations
- Creates timestamped backups (e.g., `nvim.backup.20250204_130000`)
- Preserves correct symlinks (idempotent)
- Warns about incorrect symlinks before replacing

## Common Tasks

### Adding a new dotfile
```bash
# 1. Create directory
mkdir -p <tool-name>

# 2. Add config files
cp ~/.config/<tool-name>/* <tool-name>/

# 3. Update install.sh
# Add link_config "<tool-name>" in main()

# 4. Test
./install.sh -n
```

### Updating Neovim plugins
```bash
cd ~/dotfiles/nvim
nvim
# In Neovim: :Lazy sync
# Commit updated lazy-lock.json
```

### Syncing to a new machine
```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Troubleshooting

### Symlink not working
- Check symlink: `ls -la ~/.config/<app>`
- Verify source exists: `ls ~/dotfiles/<app>`
- Re-run install: `./install.sh -f`

### Git tracking issues
- Check ignored patterns: `git check-ignore -v <file>`
- Review `.gitignore` files (root and app-level)

### Backup recovery
```bash
# List backups
ls -la ~/.config/*.backup.*

# Restore if needed
rm ~/.config/nvim  # Remove symlink
mv ~/.config/nvim.backup.YYYYMMDD_HHMMSS ~/.config/nvim
```

## Notes

- This repository follows t_wada's TDD principles for infrastructure changes
- Use small, incremental changes
- Test each step before proceeding
- Keep documentation up-to-date with structural changes
