#!/bin/bash
set -e

# Dotfiles installation script
# Creates symlinks from home directory to dotfiles repository

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Options
FORCE=false
DRY_RUN=false
VERBOSE=false

# Parse command line options
while getopts "fnvh" opt; do
  case $opt in
    f)
      FORCE=true
      ;;
    n)
      DRY_RUN=true
      ;;
    v)
      VERBOSE=true
      ;;
    h)
      echo "Usage: $0 [-f] [-n] [-v] [-h]"
      echo "  -f  Force mode (skip confirmations)"
      echo "  -n  Dry-run mode (show what would be done)"
      echo "  -v  Verbose output"
      echo "  -h  Show this help message"
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Logging functions
log_info() {
  echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
  echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
  echo -e "${RED}✗${NC} $1" >&2
}

log_verbose() {
  if [ "$VERBOSE" = true ]; then
    echo -e "  ${NC}$1"
  fi
}

# Create backup with timestamp
backup_if_exists() {
  local target=$1

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
    if [ "$DRY_RUN" = true ]; then
      log_info "Would backup $target to $backup"
    else
      log_warning "Backing up existing config to $backup"
      mv "$target" "$backup"
      log_verbose "Backup created at $backup"
    fi
    return 0
  fi
  return 1
}

# Link configuration
link_config() {
  local name=$1
  local target="$CONFIG_DIR/$name"
  local source="$DOTFILES_DIR/$name"

  log_info "Processing $name..."

  # Check if source exists
  if [ ! -e "$source" ]; then
    log_error "Source $source does not exist"
    return 1
  fi

  # Check if target is already a correct symlink
  if [ -L "$target" ]; then
    local current_target=$(readlink -f "$target")
    if [ "$current_target" = "$source" ]; then
      log_success "$name already linked correctly"
      return 0
    else
      log_warning "$name points to $current_target (expected $source)"
      if [ "$FORCE" = true ]; then
        if [ "$DRY_RUN" = true ]; then
          log_info "Would remove incorrect symlink"
        else
          rm "$target"
          log_verbose "Removed incorrect symlink"
        fi
      else
        read -p "Replace with correct link? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
          log_info "Skipped $name"
          return 0
        fi
        if [ "$DRY_RUN" = false ]; then
          rm "$target"
        fi
      fi
    fi
  elif [ -e "$target" ]; then
    # Target exists as file or directory
    backup_if_exists "$target"
  fi

  # Create parent directory if needed
  local parent_dir=$(dirname "$target")
  if [ ! -d "$parent_dir" ]; then
    if [ "$DRY_RUN" = true ]; then
      log_info "Would create directory $parent_dir"
    else
      mkdir -p "$parent_dir"
      log_verbose "Created directory $parent_dir"
    fi
  fi

  # Create symlink
  if [ "$DRY_RUN" = true ]; then
    log_info "Would link $target -> $source"
  else
    ln -s "$source" "$target"
    log_verbose "Created symlink $target -> $source"
  fi

  # Verify symlink
  if [ "$DRY_RUN" = false ]; then
    if [ -L "$target" ] && [ "$(readlink -f "$target")" = "$source" ]; then
      log_success "$name linked successfully"
    else
      log_error "Failed to create symlink for $name"
      return 1
    fi
  fi

  return 0
}

# Link configuration to home directory
link_home_config() {
  local name=$1
  local filename=$2  # Filename in home directory (e.g., .zshrc)
  local target="$HOME/$filename"
  local source="$DOTFILES_DIR/$name/$filename"

  log_info "Processing $filename..."

  # Check if source exists
  if [ ! -e "$source" ]; then
    log_error "Source $source does not exist"
    return 1
  fi

  # Check if target is already a correct symlink
  if [ -L "$target" ]; then
    local current_target=$(readlink -f "$target")
    if [ "$current_target" = "$source" ]; then
      log_success "$filename already linked correctly"
      return 0
    else
      log_warning "$filename points to $current_target (expected $source)"
      if [ "$FORCE" = true ]; then
        if [ "$DRY_RUN" = true ]; then
          log_info "Would remove incorrect symlink"
        else
          rm "$target"
          log_verbose "Removed incorrect symlink"
        fi
      else
        read -p "Replace with correct link? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
          log_info "Skipped $filename"
          return 0
        fi
        if [ "$DRY_RUN" = false ]; then
          rm "$target"
        fi
      fi
    fi
  elif [ -e "$target" ]; then
    # Target exists as file or directory
    backup_if_exists "$target"
  fi

  # Create symlink
  if [ "$DRY_RUN" = true ]; then
    log_info "Would link $target -> $source"
  else
    ln -s "$source" "$target"
    log_verbose "Created symlink $target -> $source"
  fi

  # Verify symlink
  if [ "$DRY_RUN" = false ]; then
    if [ -L "$target" ] && [ "$(readlink -f "$target")" = "$source" ]; then
      log_success "$filename linked successfully"
    else
      log_error "Failed to create symlink for $filename"
      return 1
    fi
  fi

  return 0
}

# Main installation
main() {
  echo -e "${BLUE}=== Dotfiles Installation ===${NC}\n"

  if [ "$DRY_RUN" = true ]; then
    log_warning "DRY-RUN MODE: No changes will be made"
    echo
  fi

  # Check if dotfiles directory exists
  if [ ! -d "$DOTFILES_DIR" ]; then
    log_error "Dotfiles directory $DOTFILES_DIR does not exist"
    exit 1
  fi

  # Link nvim configuration
  link_config "nvim"

  # Link starship configuration (file, not directory)
  starship_target="$CONFIG_DIR/starship.toml"
  starship_source="$DOTFILES_DIR/starship/starship.toml"
  log_info "Processing starship.toml..."
  if [ ! -e "$starship_source" ]; then
    log_error "Source $starship_source does not exist"
  else
    if [ -L "$starship_target" ] && [ "$(readlink -f "$starship_target")" = "$starship_source" ]; then
      log_success "starship.toml already linked correctly"
    else
      [ -e "$starship_target" ] && backup_if_exists "$starship_target"
      if [ "$DRY_RUN" = true ]; then
        log_info "Would link $starship_target -> $starship_source"
      else
        ln -s "$starship_source" "$starship_target"
        log_success "starship.toml linked successfully"
      fi
    fi
  fi

  # Link zsh configuration
  link_home_config "zsh" ".zshrc"

  echo
  if [ "$DRY_RUN" = true ]; then
    log_info "Dry-run completed. Run without -n to apply changes."
  else
    log_success "Installation complete!"
    echo
    log_info "Next steps:"
    echo "  Neovim:"
    echo "    1. Launch Neovim: nvim"
    echo "    2. Plugins will install automatically on first run"
    echo "    3. Check health: :checkhealth"
    echo
    echo "  Zsh:"
    echo "    1. Change default shell: chsh -s \$(which zsh)"
    echo "    2. Restart terminal or run: zsh"
    echo "    3. Verify setup: echo \$SHELL"
  fi
}

main "$@"
