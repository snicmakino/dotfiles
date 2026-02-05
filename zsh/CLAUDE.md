# zsh Configuration

This directory contains zsh shell configuration using zinit plugin manager and Starship prompt.

## Overview

The configuration provides a modern, lightweight shell environment with:
- zinit plugin manager with Turbo Mode (deferred loading)
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
- `~/.local/share/zinit/` - zinit installation directory (auto-installed)
- `~/.config/starship.toml` - Starship configuration (managed in dotfiles/starship/)

## Plugin Manager: zinit

zinit is a flexible and fast zsh plugin manager with advanced features like Turbo Mode.

### Turbo Mode

Plugins are loaded after the prompt is displayed, making shell startup instant:

```zsh
# wait: defer loading until after prompt
# lucid: suppress loading messages
zinit wait lucid for \
    zsh-users/zsh-autosuggestions
```

### Installed Plugins

1. **fast-syntax-highlighting** - Syntax highlighting for commands as you type
2. **zsh-autosuggestions** - Fish-like autosuggestions based on history
3. **zsh-history-substring-search** - Search command history with partial matches

### Adding New Plugins

Edit `.zshrc` and add a `zinit` line:

```zsh
# Basic plugin
zinit light zsh-users/zsh-completions

# With Turbo Mode (recommended)
zinit wait lucid for \
    zsh-users/zsh-completions
```

zinit will automatically download and load the plugin.

### Removing Plugins

1. Remove the `zinit` line from `.zshrc`
2. Restart zsh
3. (Optional) Remove plugin directory:
   ```bash
   rm -rf ~/.local/share/zinit/plugins/plugin-name
   ```

### Updating Plugins

```bash
zinit update --all
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

## Performance

### Startup Time

- **Target**: < 200ms
- **Current**: ~150-180ms

### Optimization Techniques

1. **zinit Turbo Mode**: Plugins load after prompt display
2. **NVM lazy loading**: NVM loads only when `nvm`, `node`, `npm`, or `npx` is called
3. **WSL env lazy evaluation**: WSL environment variables calculated on-demand

### Measuring Startup Time

```bash
time zsh -i -c exit
```

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

Environment variables for React Native development (loaded on-demand):
```bash
_setup_wsl_env  # Call this when needed
```

### Rust/Cargo

Cargo environment is automatically sourced if `~/.cargo/env` exists.

## Custom Configuration

### Adding Aliases

Add aliases to the "Aliases" section in `.zshrc`:

```bash
alias myalias='command'
```

### Adding Environment Variables

Add to the "PATH Configuration" section:

```bash
export MY_VAR="value"
export PATH="$PATH:/my/custom/path"
```

## Troubleshooting

### Slow Shell Startup

1. **Measure startup time:**
   ```bash
   time zsh -i -c exit
   ```

2. **Profile with zprof:**
   Add `zmodload zsh/zprof` at the start of `.zshrc` and `zprof` at the end.

### Plugins Not Working

1. **Check zinit installation:**
   ```bash
   ls ~/.local/share/zinit/
   ```

2. **Reinstall plugins:**
   ```bash
   rm -rf ~/.local/share/zinit/plugins/*
   exec zsh
   ```

### Autosuggestions Not Visible

Adjust highlight style in `.zshrc`:
```bash
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=245'
```

### Starship Not Loading

1. **Check if starship is installed:**
   ```bash
   which starship
   starship --version
   ```

2. **Install if missing:**
   ```bash
   curl -sS https://starship.rs/install.sh | sh
   ```

## Resources

- [zinit](https://github.com/zdharma-continuum/zinit)
- [Starship Prompt](https://starship.rs/)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting)
- [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)
