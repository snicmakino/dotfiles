#!/usr/bin/env bash
set -euo pipefail

# ==========================================
# Bootstrap script for dotfiles
# Installs required tools for the dotfiles configuration.
# Run this before install.sh on a new machine.
# ==========================================

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

info()    { echo -e "${BOLD}[bootstrap]${RESET} $*"; }
success() { echo -e "${GREEN}[bootstrap]${RESET} $*"; }
skip()    { echo -e "${YELLOW}[bootstrap]${RESET} $* (already installed, skipping)"; }

# ------------------------------------------
# starship
# ------------------------------------------
if command -v starship &>/dev/null; then
  skip "starship $(starship --version)"
else
  info "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
  success "starship installed"
fi

# ------------------------------------------
# mise
# ------------------------------------------
if command -v mise &>/dev/null; then
  skip "mise $(mise --version)"
else
  info "Installing mise..."
  curl https://mise.run | sh
  success "mise installed"
fi

# ------------------------------------------
# Neovim
# ------------------------------------------
if command -v nvim &>/dev/null; then
  skip "nvim $(nvim --version | head -1)"
else
  info "Installing Neovim..."
  NVIM_VERSION="v0.10.4"
  NVIM_ARCHIVE="nvim-linux-x86_64.tar.gz"
  curl -L "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${NVIM_ARCHIVE}" \
    -o "/tmp/${NVIM_ARCHIVE}"
  sudo tar -C /opt -xzf "/tmp/${NVIM_ARCHIVE}"
  rm "/tmp/${NVIM_ARCHIVE}"
  success "Neovim installed to /opt/nvim-linux-x86_64"
fi

# ------------------------------------------
# mise-managed tools (node, bun, pnpm, yarn, ghq)
# ------------------------------------------
MISE_BIN="${HOME}/.local/bin/mise"
if [[ -x "$MISE_BIN" ]] || command -v mise &>/dev/null; then
  MISE="${MISE_BIN:-mise}"
  info "Installing mise-managed tools from mise/config.toml..."
  MISE_CONFIG_FILE="$(dirname "$0")/mise/config.toml" "$MISE" install --yes
  success "mise tools installed"
else
  info "mise not found, skipping runtime installs"
fi

echo ""
success "Bootstrap complete! Run ./install.sh to set up symlinks."
