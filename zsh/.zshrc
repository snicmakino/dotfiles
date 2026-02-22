# ==========================================
# Zinit Plugin Manager
# ==========================================
# https://github.com/zdharma-continuum/zinit

# Zinit の初期化
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -f $ZINIT_HOME/zinit.zsh ]]; then
    print -P "%F{33}Installing zinit...%f"
    command mkdir -p "$(dirname $ZINIT_HOME)"
    command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

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

# Command correction
setopt CORRECT

# ==========================================
# Plugins (Turbo Mode - 遅延読み込み)
# ==========================================
# wait: プロンプト表示後に読み込み
# lucid: 読み込みメッセージを非表示

# 補完システム（プロンプト後に初期化）
zinit wait lucid for \
    atinit"autoload -Uz compinit && compinit -i" \
    zdharma-continuum/fast-syntax-highlighting

# autosuggestions: 履歴ベースの補完候補
zinit wait lucid for \
    atload"ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'" \
    zsh-users/zsh-autosuggestions

# history-substring-search: 部分一致で履歴検索
zinit wait lucid for \
    atload"bindkey '^[[A' history-substring-search-up; bindkey '^[[B' history-substring-search-down" \
    zsh-users/zsh-history-substring-search

# ==========================================
# Completion Settings
# ==========================================
# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# ==========================================
# Key Bindings
# ==========================================
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
# WezTerm Integration
# ==========================================
# カレントディレクトリをWeztermに通知（OSC 7シーケンス）
if [[ "$TERM_PROGRAM" == "WezTerm" ]]; then
  precmd() {
    printf "\033]7;file://%s%s\033\\" "$HOSTNAME" "$PWD"
  }
fi

# ==========================================
# User Configuration
# ==========================================

# Editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# ==========================================
# Colors Configuration
# ==========================================

# Enable colors for ls
alias ls='ls --color=auto'

# Better colors for directories and file types
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'

# Enable colors for grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ==========================================
# Aliases
# ==========================================
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
# mise (polyglot runtime manager)
# ==========================================
# https://mise.jdx.dev/
eval "$(/home/makino/.local/bin/mise activate zsh)"

# ==========================================
# WSL/Expo/Android Development Environment
# ==========================================
# 遅延評価: 必要な時に手動で _setup_wsl_env を実行
_setup_wsl_env() {
  export WSL_HOST=$(tail -1 /etc/resolv.conf | cut -d' ' -f2)
  export ADB_SERVER_SOCKET=tcp:$WSL_HOST:5037
  export ADB_TRACE=adb
  export EXPO_DEBUG=1
  export ANDROID_SERIAL=emulator-5554
  export REACT_NATIVE_PACKAGER_HOSTNAME=$(ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
}
