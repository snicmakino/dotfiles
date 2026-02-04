# zsh Configuration

This directory contains zsh shell configuration using Oh My Zsh framework.

## Overview

The configuration provides a feature-rich shell environment with:
- Oh My Zsh framework for plugin and theme management
- Syntax highlighting and autosuggestions
- Enhanced command completion
- Git integration
- Docker command completion

## File Structure

```
~/dotfiles/zsh/
├── .zshrc          # Main zsh configuration file
└── CLAUDE.md       # This documentation
```

**Symlink mapping:**
- `~/.zshrc` → `~/dotfiles/zsh/.zshrc`

**External dependencies:**
- `~/.oh-my-zsh/` - Oh My Zsh installation directory (managed separately)

## Oh My Zsh Plugins

### Enabled Plugins

1. **git** - Git aliases and prompt integration
2. **docker** - Docker command completion
3. **sudo** - Press ESC twice to add sudo to current/previous command
4. **history-substring-search** - Search command history with up/down arrows
5. **zsh-autosuggestions** - Fish-like command suggestions based on history
6. **zsh-syntax-highlighting** - Syntax highlighting for commands as you type

### Plugin Installation

The following plugins require manual installation (already done during setup):

```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

## Key Features

### Enabled Settings

- **HYPHEN_INSENSITIVE**: Case-insensitive completion, _ and - are interchangeable
- **ENABLE_CORRECTION**: Automatic command correction suggestions
- **COMPLETION_WAITING_DOTS**: Show dots while waiting for completion
- **HIST_STAMPS**: Timestamp format in history (yyyy-mm-dd)
- **Auto-update**: Oh My Zsh updates automatically every 13 days

### Editor Configuration

- Default editor: `nvim` (local sessions)
- SSH sessions: `vim`

### Custom Aliases

```bash
ll='ls -alF'      # Detailed list with indicators
la='ls -A'        # List almost all
l='ls -CF'        # List in columns with indicators
vim='nvim'        # Use neovim instead of vim
vi='nvim'         # Use neovim for vi command
```

## Theme

Currently using: `robbyrussell` (Oh My Zsh default)

### Changing Theme

To change the theme, edit `.zshrc`:

```bash
ZSH_THEME="theme-name"
```

Popular themes:
- `robbyrussell` - Simple, shows git branch
- `agnoster` - Powerline-style (requires powerline fonts)
- `powerlevel10k` - Highly customizable (requires separate installation)

## Adding Custom Configuration

### Method 1: Edit .zshrc directly

Add custom settings at the end of `~/dotfiles/zsh/.zshrc`:

```bash
# Custom environment variables
export MY_VAR="value"

# Custom aliases
alias myalias="command"
```

### Method 2: Use Oh My Zsh custom folder

Create files in `~/.oh-my-zsh/custom/`:

```bash
# Create a custom file
echo 'alias myalias="command"' > ~/.oh-my-zsh/custom/my-aliases.zsh
```

Files in the custom folder are automatically loaded.

## Troubleshooting

### Slow Shell Startup

If shell startup is slow:

1. Check which plugins are loaded:
   ```bash
   echo $plugins
   ```

2. Disable unused plugins in `.zshrc`

3. Profile startup time:
   ```bash
   time zsh -i -c exit
   ```

### Plugin Not Working

1. Verify plugin is installed:
   ```bash
   ls ~/.oh-my-zsh/custom/plugins/
   ```

2. Check plugin is listed in `.zshrc`:
   ```bash
   grep "plugins=" ~/.zshrc
   ```

3. Reload configuration:
   ```bash
   source ~/.zshrc
   ```

### Autosuggestions Not Visible

The suggestions appear in a dim gray color. If not visible:

```bash
# Adjust highlight style in .zshrc
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
```

Try different colors (0-255) if still not visible.

## Maintenance

### Update Oh My Zsh

Oh My Zsh auto-updates by default. To update manually:

```bash
omz update
```

### Update Plugins

Navigate to plugin directory and pull latest changes:

```bash
cd ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git pull

cd ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git pull
```

### Backup and Sync

The main `.zshrc` is managed by dotfiles. Other components:

- `~/.oh-my-zsh/` - Not tracked (can be reinstalled)
- Custom plugins in `~/.oh-my-zsh/custom/plugins/` - Not tracked (can be reinstalled)
- Custom themes/scripts in `~/.oh-my-zsh/custom/` - Consider tracking if heavily customized

## Migration from Bash

If you have bash configurations to migrate:

1. Check existing bash aliases:
   ```bash
   grep alias ~/.bashrc
   ```

2. Copy relevant aliases to `.zshrc`

3. Check bash environment variables:
   ```bash
   grep export ~/.bashrc
   ```

4. Copy relevant exports to `.zshrc`

5. Test in a new zsh session before committing changes

## Resources

- [Oh My Zsh Documentation](https://github.com/ohmyzsh/ohmyzsh)
- [Oh My Zsh Plugins List](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins)
- [Oh My Zsh Themes](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
