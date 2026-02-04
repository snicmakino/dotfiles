# WezTerm Configuration

WezTerm ターミナルエミュレータの設定ファイル管理。

## Overview

- **実行環境**: Windows
- **設定ファイル**: `C:\Users\makin\.wezterm.lua`
- **管理方法**: Windows シンボリックリンク経由で dotfiles と同期

## File Structure

```
~/dotfiles/wezterm/
└── .wezterm.lua    # メイン設定ファイル
```

## Setup

### 初回セットアップ（Windows 側で実行）

管理者権限で PowerShell または コマンドプロンプトを開き、以下を実行:

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

**注意事項:**
- シンボリックリンク作成には管理者権限が必要
- `\\wsl.localhost\Ubuntu` は WSL2 のデフォルトネットワークパス
- WSL ディストリビューション名が異なる場合は適宜変更
- パスのユーザー名 (`makino`) を環境に合わせて変更

### 確認方法

PowerShell で以下を実行してシンボリックリンクを確認:

```powershell
Get-Item $env:USERPROFILE\.wezterm.lua | Select-Object LinkType, Target
```

## Configuration

### 主な設定内容

現在の設定には以下が含まれています:

- **カラースキーム**: AdventureTime
- **デフォルトドメイン**: WSL:Ubuntu
- **リーダーキー**: `Ctrl+a` (tmux スタイル)

#### キーバインディング

| キー | 動作 |
|------|------|
| `Leader + [` | 水平分割 |
| `Leader + ]` | 垂直分割 |
| `Leader + h/j/k/l` | ペイン移動 (Vim スタイル) |
| `Leader + x` | ペインを閉じる |
| `Leader + c` | 新しいタブ |
| `Leader + n` | 次のタブ |
| `Leader + p` | 前のタブ |

リーダーキーが有効な場合、ステータスバーに "LEADER" と表示されます。

### 設定の変更

1. WSL 側で設定ファイルを編集:
   ```bash
   cd ~/dotfiles/wezterm
   nvim .wezterm.lua
   ```

2. 変更を保存してコミット:
   ```bash
   git add .wezterm.lua
   git commit -m "Update WezTerm configuration"
   ```

3. WezTerm を再起動すると自動的に反映されます

## Troubleshooting

### シンボリックリンクが機能しない

**症状**: 設定変更が反映されない

**確認項目**:
1. シンボリックリンクが正しく作成されているか確認
   ```powershell
   Get-Item $env:USERPROFILE\.wezterm.lua
   ```

2. WSL が起動しているか確認
   ```powershell
   wsl --list --running
   ```

3. ネットワークパスにアクセスできるか確認
   ```powershell
   Test-Path "\\wsl.localhost\Ubuntu\home\makino\dotfiles\wezterm\.wezterm.lua"
   ```

**解決方法**:
- シンボリックリンクを削除して再作成
- WSL を再起動: `wsl --shutdown` → WSL を起動

### 設定ファイルのエラー

**症状**: WezTerm 起動時にエラーが表示される

**確認方法**:
```bash
# WSL 側でシンタックスチェック
cd ~/dotfiles/wezterm
lua .wezterm.lua
```

### パフォーマンス問題

WSL ネットワークパス経由のアクセスが遅い場合:
- WezTerm の起動は通常問題なし（設定は起動時のみ読み込まれる）
- 設定変更の反映には WezTerm の再起動が必要

## Migration to Other Machines

新しいマシンで同じ設定を使用する場合:

1. dotfiles リポジトリをクローン（WSL 側）
   ```bash
   git clone <repo-url> ~/dotfiles
   ```

2. Windows 側でシンボリックリンクを作成（上記の「初回セットアップ」を参照）

3. WezTerm を起動して設定を確認

## Notes

- WezTerm は Windows で実行されるため、`install.sh` では管理できません
- WSL/Windows のファイルシステム境界を越えるため、手動セットアップが必要
- 設定ファイルの変更は WSL 側で行い、Git で管理します
- Windows 側のシンボリックリンクは一度作成すれば、その後の変更は自動的に反映されます
