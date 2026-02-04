# Dotfiles

個人用の開発環境設定ファイル群です。

## 内容

- **nvim**: Neovim設定（lazy.nvimプラグインマネージャー使用）
- **zsh**: Zsh設定（Zapプラグインマネージャー + Starshipプロンプト）
- **starship**: Starshipプロンプト設定（Rust製の高速プロンプト）
- **wezterm**: WezTermターミナル設定（Windows側で動作、特殊なセットアップが必要）

## 前提条件

- Git
- Zsh
- Neovim >= 0.9.0
- Rust/Cargo（Starshipのインストールに必要）
- WSL2（Windowsユーザーの場合）

## クイックスタート

```bash
# リポジトリをクローン
git clone <your-repo-url> ~/dotfiles

# インストールスクリプトを実行
cd ~/dotfiles
./install.sh

# Neovimを起動（初回起動時にプラグインが自動インストールされます）
nvim
```

## インストール詳細

`install.sh`スクリプトは、ホームディレクトリからこのリポジトリへのシンボリックリンクを作成します:

- `~/.config/nvim` → `~/dotfiles/nvim`
- `~/.config/starship.toml` → `~/dotfiles/starship/starship.toml`
- `~/.zshrc` → `~/dotfiles/zsh/.zshrc`

### スクリプトオプション

```bash
./install.sh           # 対話的インストール
./install.sh -f        # 強制モード（確認をスキップ）
./install.sh -n        # ドライラン（実行内容を表示のみ）
./install.sh -v        # 詳細出力
./install.sh -h        # ヘルプを表示
```

### バックアップ動作

既存の設定がある場合、以下のようにバックアップされます:
- `~/.config/nvim.backup.YYYYMMDD_HHMMSS`

## WezTerm セットアップ（Windows）

WezTermはWindows側で動作するため、設定には特殊な対応が必要です。

詳細は [wezterm/CLAUDE.md](wezterm/CLAUDE.md) を参照してください。

### シンボリックリンクによるセットアップ（推奨）

**管理者権限で** PowerShell または コマンドプロンプトを開き、以下を実行:

```powershell
# PowerShell の場合
cd $env:USERPROFILE
Remove-Item .wezterm.lua -ErrorAction SilentlyContinue
New-Item -ItemType SymbolicLink -Path .wezterm.lua -Target "\\wsl.localhost\Ubuntu\home\makino\dotfiles\wezterm\.wezterm.lua"
```

```cmd
REM コマンドプロンプトの場合
cd %USERPROFILE%
del .wezterm.lua
mklink .wezterm.lua "\\wsl.localhost\Ubuntu\home\makino\dotfiles\wezterm\.wezterm.lua"
```

設定変更はWSL側で行い、Gitで管理します。WezTermを再起動すると自動的に反映されます。

**注意事項:**
- シンボリックリンク作成には管理者権限が必要
- ユーザー名やWSLディストリビューション名は環境に合わせて変更してください
- シンボリックリンクの確認: `Get-Item $env:USERPROFILE\.wezterm.lua | Select-Object LinkType, Target`

## 更新

```bash
cd ~/dotfiles
git pull
# Neovimを再起動してプラグイン更新を適用
```

## ディレクトリ構造

```
dotfiles/
├── nvim/              # Neovim設定
│   ├── init.lua       # エントリーポイント
│   ├── lazy-lock.json # プラグインバージョン（再現性のため）
│   └── lua/
│       ├── plugins.lua      # プラグイン定義
│       └── config/
│           ├── options.lua  # Vimオプション
│           ├── keymaps.lua  # キーバインド
│           └── lsp.lua      # LSP設定
├── zsh/               # Zsh設定
│   ├── .zshrc         # Zsh設定ファイル
│   └── CLAUDE.md      # Zsh設定ガイド
├── starship/          # Starshipプロンプト設定
│   ├── starship.toml  # Starship設定ファイル
│   └── CLAUDE.md      # Starship設定ガイド
├── wezterm/           # WezTerm設定
│   ├── .wezterm.lua   # WezTerm設定ファイル
│   └── CLAUDE.md      # WezTerm設定ガイド
├── install.sh         # シンボリックリンク作成スクリプト
└── README.md          # このファイル
```

## Neovim設定

詳細なNeovim設定のドキュメントは[nvim/CLAUDE.md](nvim/CLAUDE.md)を参照してください。

**主要機能:**
- lazy.nvimによる遅延読み込みプラグイン
- Lua、TypeScript/JavaScript、Kotlin用LSPサポート
- conform.nvimによる自動フォーマット
- vim-testによる統合テスト環境
- Claude Code統合

**主要キーマップ（Space + キー）:**

| キー | 動作 |
|------|------|
| `e` | ファイルツリーを切り替え |
| `ff/fg/fb` | Telescope: ファイル/grep/バッファ |
| `F` | バッファをフォーマット |
| `gg` | LazyGit |
| `xx/xd` | Trouble: 全診断/バッファ診断 |
| `Tn/Tf/Tl/Ta` | テスト: 最近/ファイル/最後/全て |
| `tt/th/tv/tf` | ターミナル: 切り替え/水平/垂直/フロート |
| `ac/af` | Claude Code: 切り替え/フォーカス |
| `rr` | HTTPリクエスト実行（kulala） |
| `gd/K/rn/ca` | LSP: 定義/ホバー/リネーム/コードアクション |

## Zsh設定

詳細なZsh設定のドキュメントは[zsh/CLAUDE.md](zsh/CLAUDE.md)を参照してください。

**主要機能:**
- Zapプラグインマネージャーによる軽量なプラグイン管理
- Starshipプロンプト（高速で情報豊富）
- Fish風のコマンド補完とシンタックスハイライト
- NVM遅延ロードによる高速起動（約180ms）
- WSL/Windows統合（1Password SSH、Android開発）

**主要エイリアス:**

| エイリアス | 動作 |
|-----------|------|
| `ll` | 詳細なファイル一覧 |
| `vim/vi` | Neovimを起動 |
| `ssh` | Windows SSH（1Password統合） |

**キーバインド:**

| キー | 動作 |
|------|------|
| `↑/↓` | 履歴を部分文字列検索 |
| `ESC ESC` | コマンドの先頭にsudoを追加/削除 |

## Starship設定

詳細なStarship設定のドキュメントは[starship/CLAUDE.md](starship/CLAUDE.md)を参照してください。

**主要機能:**
- Gitブランチとステータス表示
- 言語バージョン自動検出（Node.js、Rust、Python等）
- コマンド実行時間表示（2秒以上）
- エラーステータス表示
- カスタマイズ可能なTOML設定

**プロンプト形式:**
```
┌─[username][@hostname] /path/to/directory  main !?
└─❯
```

## トラブルシューティング

### シンボリックリンクが作成されない

権限を確認し、スクリプトが実行可能であることを確認してください:
```bash
chmod +x install.sh
```

### Neovim起動時のエラー

プラグインデータを削除して再インストール:
```bash
rm -rf ~/.local/share/nvim
nvim  # プラグインが自動的に再インストールされます
```

### WezTermが設定を読み込まない

設定ファイルの場所を確認:
```powershell
# Windows PowerShellで
Test-Path C:\Users\<YourUsername>\.config\wezterm\wezterm.lua
```

### install.sh実行後もNeovimが古い設定を使用している

既存の`~/.config/nvim`がシンボリックリンクに置き換わっているか確認:
```bash
ls -la ~/.config/nvim
# 出力例: nvim -> /home/makino/dotfiles/nvim
```

シンボリックリンクでない場合、手動でバックアップして再実行:
```bash
mv ~/.config/nvim ~/.config/nvim.backup.manual
./install.sh
```

## ライセンス

MIT
