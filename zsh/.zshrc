# ==========================================
# Zap Plugin Manager
# ==========================================
# https://github.com/zap-zsh/zap

# Zapの初期化
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

# プラグインのインストール
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-history-substring-search"

# ==========================================
# Zsh Configuration
# ==========================================

# 履歴設定
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

# 補完設定
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Command correction
setopt CORRECT

# zsh-autosuggestions configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

# Key bindings
# history-substring-search: 上下キーで履歴検索
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# sudo機能: ESCキー2回で現在のコマンドの先頭にsudoを追加
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line  # ESC ESC

# ==========================================
# Rust/Cargo Environment (starshipに必要)
# ==========================================
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# ==========================================
# Starship Prompt
# ==========================================
eval "$(starship init zsh)"

# ==========================================
# User Configuration
# ==========================================

# Editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias vim='nvim'
alias vi='nvim'

# ==========================================
# PATH Configuration
# ==========================================

# pipx
export PATH="$PATH:$HOME/.local/bin"

# mssql-tools18
export PATH="$PATH:/opt/mssql-tools18/bin"

# Neovim
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# Claude CLI
export PATH="$PATH:$HOME/.local/bin/claude"

# ==========================================
# NVM (Node Version Manager) - Lazy Loading
# ==========================================
# NVMを遅延ロードして起動時間を大幅改善
export NVM_DIR="$HOME/.nvm"

# nvmコマンドが呼ばれたときだけNVMをロード
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

# nodeコマンドが呼ばれたときだけNVMをロード
node() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  node "$@"
}

# npmコマンドが呼ばれたときだけNVMをロード
npm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  npm "$@"
}

# npxコマンドが呼ばれたときだけNVMをロード
npx() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  npx "$@"
}

# ==========================================
# 1Password SSH Configuration
# ==========================================
# Use Windows SSH for 1Password integration in WSL
alias ssh='ssh.exe'
alias ssh-add='ssh-add.exe'

# ==========================================
# WSL/Expo/Android Development Environment
# ==========================================
export WSL_HOST=$(tail -1 /etc/resolv.conf | cut -d' ' -f2)
export ADB_SERVER_SOCKET=tcp:$WSL_HOST:5037
export ADB_TRACE=adb
export EXPO_DEBUG=1
export ANDROID_SERIAL=emulator-5554
export REACT_NATIVE_PACKAGER_HOSTNAME=$(ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
