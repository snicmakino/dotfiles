# mise Configuration

This directory contains mise (polyglot runtime manager) configuration for managing development tools and language runtimes.

## Overview

mise is a modern, fast runtime manager that replaces version managers like nvm, rbenv, pyenv, etc. It provides:
- Unified management for multiple languages (Node.js, Python, Ruby, Go, etc.)
- Fast startup (no shell hooks overhead)
- `.tool-versions` file support (compatible with asdf)
- Per-project version management
- Global version management

**Migration Note:** This configuration replaced nvm (Node Version Manager) to provide better performance and unified tool management.

## File Structure

```
~/dotfiles/mise/
├── config.toml     # Global tool versions
└── CLAUDE.md       # This documentation
```

**Symlink mapping:**
- `~/.config/mise/config.toml` → `~/dotfiles/mise/config.toml`

**External directories:**
- `~/.local/share/mise/` - mise installation directory
- `~/.local/share/mise/installs/` - installed tools
- `~/.cache/mise/` - downloaded packages cache

## Current Configuration

```toml
[tools]
node = "22"        # Node.js LTS version 22
pnpm = "latest"    # pnpm package manager
```

## Installation

mise is automatically activated in zsh via `.zshrc`:

```zsh
eval "$(/home/makino/.local/bin/mise activate zsh)"
```

## Common Commands

### View Installed Tools

```bash
mise list
```

### Install a Tool

```bash
# Install specific version
mise install node@20.11.0

# Install latest version
mise install python@latest

# Install version specified in config.toml
mise install
```

### Use a Tool Globally

```bash
# Add to ~/.config/mise/config.toml
mise use --global node@22
mise use --global python@3.12

# Or specify exact version
mise use --global node@22.11.0
```

### Use a Tool Locally (Per-Project)

```bash
# Add to .mise.toml in current directory
cd /path/to/project
mise use node@20

# Or create .tool-versions file (asdf-compatible)
echo "node 20.11.0" > .tool-versions
```

### Update Tools

```bash
# Update mise itself
mise self-update

# Update all tools to latest versions
mise upgrade
```

### Remove a Tool Version

```bash
mise uninstall node@20.11.0
```

## Supported Languages and Tools

mise supports many languages and tools through multiple backends:

### Core Languages
- **Node.js**: `mise use node@22`
- **Python**: `mise use python@3.12`
- **Ruby**: `mise use ruby@3.3`
- **Go**: `mise use go@1.22`
- **Rust**: `mise use rust@latest`
- **Java**: `mise use java@21`
- **Deno**: `mise use deno@latest`
- **Bun**: `mise use bun@latest`

### Package Managers
- **pnpm**: `mise use pnpm@latest` (currently installed)
- **npm**: Included with Node.js
- **yarn**: `mise use yarn@latest`

### Other Tools
- View all available tools: `mise registry`
- Search for a tool: `mise registry | grep <tool-name>`

## Configuration Files

### Global Configuration (~/.config/mise/config.toml)

Managed by dotfiles symlink. Defines default versions for all projects.

```toml
[tools]
node = "22"
python = "3.12"

[env]
# Global environment variables (optional)
```

### Per-Project Configuration

Create `.mise.toml` in project directory:

```toml
[tools]
node = "20.11.0"
pnpm = "9"
```

Or use `.tool-versions` (asdf-compatible):

```
node 20.11.0
python 3.11.5
```

## Migration from nvm

### Completed Steps

1. ✅ mise installed to `~/.local/bin/mise`
2. ✅ Node.js 22 installed via mise
3. ✅ pnpm installed via mise
4. ✅ `.zshrc` updated with mise activation
5. ✅ nvm lazy-loading configuration removed from `.zshrc`
6. ✅ mise configuration added to dotfiles

### Optional Cleanup

The old nvm directory still exists at `~/.nvm`. You can remove it if you no longer need it:

```bash
# Verify mise is working first
which node  # Should show ~/.local/share/mise/installs/node/...
mise list   # Should show installed tools

# Remove nvm directory (optional)
rm -rf ~/.nvm
```

## Performance

### Startup Time

mise has minimal impact on shell startup time:
- **mise activation**: ~5-10ms
- **nvm lazy loading** (old): ~20-30ms overhead + loading time on first use

### Installation Speed

mise downloads pre-built binaries when available, making installation much faster than building from source.

## Troubleshooting

### Tools Not Found

1. **Check if mise is activated:**
   ```bash
   mise doctor
   ```
   Should show `activated: yes`

2. **Check installed tools:**
   ```bash
   mise list
   ```

3. **Reinstall if needed:**
   ```bash
   mise install node@22
   ```

### Version Not Switching

1. **Check for local .mise.toml or .tool-versions:**
   ```bash
   ls -la .mise.toml .tool-versions
   ```

2. **Check which config is being used:**
   ```bash
   mise current
   ```

3. **Debug with verbose output:**
   ```bash
   mise exec --verbose -- node --version
   ```

### mise Command Not Found

1. **Check if mise is installed:**
   ```bash
   ls -la ~/.local/bin/mise
   ```

2. **Re-activate in current shell:**
   ```bash
   eval "$(/home/makino/.local/bin/mise activate zsh)"
   ```

3. **Restart shell:**
   ```bash
   exec zsh
   ```

## Adding New Tools

When adding a new tool to mise:

1. Add to global config (if needed globally):
   ```bash
   cd ~/dotfiles/mise
   mise use --global <tool>@<version>
   ```

2. Commit the updated `config.toml`:
   ```bash
   git add config.toml
   git commit -m "feat: add <tool> to mise configuration"
   ```

## Resources

- [mise Documentation](https://mise.jdx.dev/)
- [mise Registry](https://mise.jdx.dev/registry.html)
- [GitHub Repository](https://github.com/jdx/mise)
- [Migration from asdf](https://mise.jdx.dev/migrating-from-asdf.html)
