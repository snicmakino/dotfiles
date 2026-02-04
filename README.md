# Dotfiles

個人用の開発環境設定ファイル群です。

## 内容

- **nvim**: Neovim設定（lazy.nvimプラグインマネージャー使用）
- **wezterm**: WezTermターミナル設定（Windows側で動作、特殊なセットアップが必要）

## 前提条件

- Git
- Neovim >= 0.9.0
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

### 手動セットアップ（現在推奨）

1. Windows側に設定ディレクトリを作成:
   ```powershell
   mkdir C:\Users\<YourUsername>\.config\wezterm
   ```

2. 設定ファイルをコピーまたはシンボリックリンク:
   ```powershell
   # オプション A: コピー（手動で同期が必要）
   copy \\wsl$\Ubuntu\home\makino\dotfiles\wezterm\wezterm.lua C:\Users\<YourUsername>\.config\wezterm\

   # オプション B: シンボリックリンク（開発者モードまたは管理者権限が必要）
   cd C:\Users\<YourUsername>\.config\wezterm
   mklink wezterm.lua \\wsl$\Ubuntu\home\makino\dotfiles\wezterm\wezterm.lua
   ```

3. WezTermを再起動して変更を適用

**注意:** Windows側でシンボリックリンクを作成するには:
- 開発者モードを有効にする、または
- 管理者権限でコマンドを実行する必要があります

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
├── wezterm/           # WezTerm設定
│   └── .placeholder   # 空ディレクトリ管理用
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
