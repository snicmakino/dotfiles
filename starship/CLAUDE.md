# Starship Configuration

This directory contains Starship prompt configuration.

## Overview

Starship is a minimal, fast, and customizable prompt for any shell. This configuration provides:
- Git branch and status information
- Language version display (Node.js, Rust, Python, etc.)
- Command execution time
- Error status indication
- Customizable format and colors

## File Structure

```
~/dotfiles/starship/
├── starship.toml    # Main configuration file
└── CLAUDE.md        # This documentation
```

**Symlink mapping:**
- `~/.config/starship.toml` → `~/dotfiles/starship/starship.toml`

## Features

### Prompt Layout

```
┌─[username][@hostname] /path/to/directory  main !?
└─❯
```

Components:
- **Username/Hostname**: Shown only in SSH connections
- **Directory**: Current directory (truncated to 3 levels)
- **Git Branch**: Current branch with icon
- **Git Status**: Shows modified (!), staged (+), untracked (?), etc.
- **Language Versions**: Automatically detected based on project files

### Git Status Symbols

| Symbol | Meaning |
|--------|---------|
| `!` | Modified files |
| `+` | Staged files |
| `?` | Untracked files |
| `$` | Stashed changes |
| `✘` | Deleted files |
| `»` | Renamed files |
| `⇡` | Ahead of remote |
| `⇣` | Behind remote |
| `🏳` | Merge conflict |

### Language Support

Starship automatically detects and displays versions for:
- **Node.js** ( icon) - when `package.json` is present
- **Rust** ( icon) - when `Cargo.toml` is present
- **Python** ( icon) - when `.py` files or `requirements.txt` is present
- **Go** ( icon) - when `go.mod` is present
- **Java** ( icon) - when `.java` files are present
- **Kotlin** (🅺 icon) - when `.kt` files are present

## Configuration

### Basic Customization

Edit `~/dotfiles/starship/starship.toml`:

```toml
# Change directory truncation length
[directory]
truncation_length = 5  # Show up to 5 directory levels

# Disable specific language version display
[nodejs]
disabled = true

# Change prompt symbol
format = """
[└─$](bold white) """
```

### Adding New Modules

Starship supports many modules. Example for adding AWS profile:

```toml
[aws]
format = '[$symbol($profile )(\($region\) )]($style)'
symbol = "☁️ "
style = "bold yellow"
```

### Color Scheme

Current colors:
- **Username**: Green (SSH only)
- **Hostname**: Blue (SSH only)
- **Directory**: Cyan
- **Git Branch**: Purple
- **Git Status**: Red
- **Command Duration**: Yellow

To change colors, edit the `style` parameter in each module.

## Performance

Starship is designed to be fast:
- Written in Rust for minimal overhead
- Asynchronous execution of module detection
- Adds ~10-50ms to prompt rendering

To optimize performance:
1. Disable unused modules by setting `disabled = true`
2. Reduce the number of displayed modules
3. Increase `command_timeout` if modules are slow

## Troubleshooting

### Icons Not Displaying

Starship uses Nerd Fonts for icons. If icons appear as boxes or question marks:

1. Install a Nerd Font: https://www.nerdfonts.com/
2. Configure your terminal to use the font (e.g., in WezTerm config)

Alternatively, disable icons:
```toml
[character]
success_symbol = ">"
error_symbol = ">"

[git_branch]
symbol = ""
```

### Slow Prompt

If the prompt feels slow:

1. Check which modules are active:
   ```bash
   starship timings
   ```

2. Disable slow modules in `starship.toml`:
   ```toml
   [slow_module]
   disabled = true
   ```

3. Increase command timeout:
   ```toml
   command_timeout = 1000  # 1 second
   ```

### Configuration Not Loading

1. Verify symlink:
   ```bash
   ls -la ~/.config/starship.toml
   # Should show: starship.toml -> /home/makino/dotfiles/starship/starship.toml
   ```

2. Check syntax:
   ```bash
   starship config
   ```

3. Test configuration:
   ```bash
   starship prompt
   ```

## Migration from Oh My Zsh Themes

### robbyrussell Theme

The current configuration provides a similar look to robbyrussell:
- Simple, single-line prompt (with optional wraparound)
- Git branch and status
- Directory path

Key differences:
- More Git status information
- Language version detection
- Command execution time display

### agnoster Theme

To mimic agnoster's powerline style, modify the format:

```toml
format = """
$username\
$hostname\
$directory\
$git_branch\
$git_status\
$line_break\
$character"""

[character]
success_symbol = "[➜](bold green) "
error_symbol = "[➜](bold red) "
```

## Advanced Features

### Conditional Display

Display modules only in specific conditions:

```toml
# Show Docker context only when in a project with Dockerfile
[docker_context]
only_with_files = true
detect_files = ['Dockerfile']
```

### Custom Commands

Execute custom commands and display output:

```toml
[custom.git_email]
command = "git config user.email"
when = "git rev-parse --is-inside-work-tree"
style = "bold dimmed white"
format = "[$output]($style) "
```

### Multi-line Prompts

The current config uses a two-line prompt. To use single-line:

```toml
format = """
$all$character"""
```

## Resources

- [Official Documentation](https://starship.rs/)
- [Configuration Reference](https://starship.rs/config/)
- [Preset Configurations](https://starship.rs/presets/)
- [GitHub Repository](https://github.com/starship/starship)

## Updating Starship

Update via cargo:
```bash
cargo install starship --locked --force
```

Or use the official installer:
```bash
curl -sS https://starship.rs/install.sh | sh
```
