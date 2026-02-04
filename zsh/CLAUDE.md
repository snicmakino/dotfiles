# zsh Configuration

This directory contains zsh shell configuration using Zap plugin manager and Starship prompt.

## Overview

The configuration provides a modern, lightweight shell environment with:
- Zap plugin manager for fast plugin loading
- Starship prompt for beautiful, informative prompts
- Essential plugins: autosuggestions, syntax highlighting, history search
- NVM lazy loading for fast startup
- WSL-specific configurations

## File Structure

```
~/dotfiles/zsh/
├── .zshrc          # Main zsh configuration file
└── CLAUDE.md       # This documentation
```

**Symlink mapping:**
- `~/.zshrc` → `~/dotfiles/zsh/.zshrc`

**External dependencies:**
- `~/.local/share/zap/` - Zap installation directory
- `~/.config/starship.toml` - Starship configuration (managed in dotfiles/starship/)

## Plugin Manager: Zap

Zap is a minimal zsh plugin manager focused on speed and simplicity.

### Installed Plugins

1. **zsh-autosuggestions** - Fish-like autosuggestions based on history
2. **zsh-syntax-highlighting** - Syntax highlighting for commands as you type
3. **zsh-history-substring-search** - Search command history with partial matches

### Adding New Plugins

Edit `.zshrc` and add a `plug` line:

```bash
plug "user/repo"  # GitHub repository
```

Example:
```bash
plug "zsh-users/zsh-completions"
```

Zap will automatically download and load the plugin on next shell startup.

### Removing Plugins

1. Remove the `plug` line from `.zshrc`
2. Restart zsh
3. (Optional) Remove plugin directory:
   ```bash
   rm -rf ~/.local/share/zap/plugins/repo-name
   ```

## Prompt: Starship

Starship is a fast, customizable prompt written in Rust. See [starship/CLAUDE.md](../starship/CLAUDE.md) for detailed configuration.

Key features:
- Git branch and status
- Language version detection (Node, Rust, Python, etc.)
- Command execution time
- Error status indication

## Key Features

### History Configuration

- **Size**: 10,000 commands
- **Location**: `~/.zsh_history`
- **Deduplication**: Duplicate commands are ignored
- **Sharing**: History is shared across all zsh sessions

### Completion

- **Case-insensitive**: `cd downloads` matches `Downloads`
- **Auto-completion**: Tab completion for commands and arguments
- **Command correction**: Suggests corrections for typos

### Key Bindings

| Key Combination | Action |
|----------------|--------|
| `↑` / `↓` | Search history by substring |
| `ESC ESC` | Add/remove `sudo` at beginning of command |
| `Ctrl+R` | Reverse history search |
| `Tab` | Auto-completion |

### Aliases

```bash
ll='ls -alF'      # Detailed list with indicators
la='ls -A'        # List almost all
l='ls -CF'        # List in columns with indicators
vim='nvim'        # Use neovim instead of vim
vi='nvim'         # Use neovim for vi command
ssh='ssh.exe'     # Use Windows SSH (WSL/1Password)
ssh-add='ssh-add.exe'  # Use Windows ssh-add
```

## Performance Optimizations

### NVM Lazy Loading

NVM (Node Version Manager) is lazy-loaded to improve startup time:
- NVM is not loaded on shell startup (~500ms saved)
- NVM loads automatically when `nvm`, `node`, `npm`, or `npx` is first used
- After first use, commands work normally

**Startup time improvement:**
- Before: ~750ms
- After: ~180ms (without zap/starship overhead)

### WSL Environment Variables

The following environment variables are calculated on each startup:
```bash
WSL_HOST                        # Windows host IP
REACT_NATIVE_PACKAGER_HOSTNAME  # WSL network IP
```

These add ~50-100ms to startup time. If not needed, comment them out in `.zshrc`.

## Platform-Specific Configurations

### WSL/Windows Integration

#### 1Password SSH Agent

Uses Windows SSH for 1Password integration:
```bash
alias ssh='ssh.exe'
alias ssh-add='ssh-add.exe'
```

**Setup:** Ensure 1Password SSH agent is enabled in Windows.

#### Android/Expo Development

Environment variables for React Native development:
```bash
ADB_SERVER_SOCKET              # Android Debug Bridge
EXPO_DEBUG                     # Expo debugging
ANDROID_SERIAL                 # Default Android device
REACT_NATIVE_PACKAGER_HOSTNAME # Metro bundler host
```

### Rust/Cargo

Cargo environment is automatically sourced if `~/.cargo/env` exists.

## Custom Configuration

### Adding Aliases

Add aliases to the "Aliases" section in `.zshrc`:

```bash
# Aliases
alias ll='ls -alF'
alias myalias='command'  # Add your aliases here
```

### Adding Environment Variables

Add to the "PATH Configuration" or create a new section:

```bash
export MY_VAR="value"
export PATH="$PATH:/my/custom/path"
```

### Custom Functions

Add functions anywhere in `.zshrc`:

```bash
# My custom function
my_function() {
  echo "Hello, $1!"
}
```

## Troubleshooting

### Slow Shell Startup

1. **Measure startup time:**
   ```bash
   time zsh -i -c exit
   ```

2. **Common causes:**
   - WSL environment variable calculation (50-100ms)
   - Zap plugin loading (first run is slower)
   - NVM loading (should be lazy-loaded)

3. **Solutions:**
   - Comment out unused WSL environment variables
   - Reduce number of plugins
   - Check for slow commands in `.zshrc`

### Plugins Not Working

1. **Check Zap installation:**
   ```bash
   ls ~/.local/share/zap/
   ```

2. **Reinstall plugins:**
   Delete plugin cache and restart:
   ```bash
   rm -rf ~/.local/share/zap/plugins/*
   zsh
   ```

3. **Verify plugin syntax:**
   ```bash
   grep "^plug" ~/.zshrc
   ```

### Autosuggestions Not Visible

The suggestions appear in a dim gray color. If not visible:

1. **Adjust highlight style in `.zshrc`:**
   ```bash
   ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
   ```

2. **Try different colors (0-255):**
   ```bash
   ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=245'
   ```

### Starship Not Loading

1. **Check if starship is installed:**
   ```bash
   which starship
   starship --version
   ```

2. **Verify initialization in `.zshrc`:**
   ```bash
   grep "starship init" ~/.zshrc
   ```

3. **Test manually:**
   ```bash
   eval "$(starship init zsh)"
   ```

## Migration Notes

### From Oh My Zsh

This configuration migrated from Oh My Zsh to Zap + Starship for:
- **Performance**: Faster startup time
- **Simplicity**: Fewer dependencies, clearer configuration
- **Modernization**: Starship's rich features and Rust performance

**What was kept:**
- All custom aliases and environment variables
- Plugin functionality (autosuggestions, syntax highlighting, history search)
- Git integration (via Starship)

**What changed:**
- Plugin manager: Oh My Zsh → Zap
- Prompt: robbyrussell theme → Starship
- Configuration style: More explicit, less magic

### Rollback

If you need to rollback to Oh My Zsh:

1. **Backup current config:**
   ```bash
   mv ~/.zshrc ~/.zshrc.zap.backup
   ```

2. **Restore Oh My Zsh config:**
   ```bash
   # Find backup
   ls -la ~/.zshrc.backup.*

   # Restore (use the appropriate timestamp)
   cp ~/.zshrc.backup.YYYYMMDD_HHMMSS ~/.zshrc
   ```

3. **Reinstall Oh My Zsh if needed:**
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

## Maintenance

### Update Zap

Zap doesn't have a built-in update mechanism. To update:

```bash
cd ~/.local/share/zap
git pull
```

### Update Plugins

Plugins are updated automatically when you restart zsh, or manually:

```bash
rm -rf ~/.local/share/zap/plugins/*
zsh  # Plugins will be re-downloaded
```

### Update Starship

```bash
cargo install starship --locked --force
```

Or use the official installer:
```bash
curl -sS https://starship.rs/install.sh | sh
```

## Resources

- [Zap Plugin Manager](https://github.com/zap-zsh/zap)
- [Starship Prompt](https://starship.rs/)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)
