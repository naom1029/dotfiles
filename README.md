# dotfiles

[chezmoi](https://www.chezmoi.io/) で管理するクロスプラットフォーム（WSL/Linux + Windows）の個人 dotfiles。

## セットアップ（新しいマシン）

`naom1029` は `github.com/naom1029/dotfiles` の短縮形。init 時に Git の `name` / `email` / `safe.directory` を対話入力する（`safe.directory` は不要なら空 Enter）。

### WSL / Linux / macOS

chezmoi の導入から適用まで一発で行う場合:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply naom1029
```

すでに chezmoi がある場合:

```sh
chezmoi init --apply naom1029
```

### Windows（PowerShell）

```powershell
iex "&{$(irm 'https://get.chezmoi.io/ps1')} -- init --apply naom1029"
```

## OS 別の振り分け

このリポジトリは 1 つで Windows と Linux/WSL を兼ねる。`.chezmoiignore` で展開対象を OS ごとに出し分けている。

| 対象 | Linux/WSL | Windows |
|------|:---------:|:-------:|
| `.bashrc` / `.profile` / nvim / tmux / lazygit / `.gitconfig` | ✅ | ❌ |
| `Documents/PowerShell`・`Documents/WindowsPowerShell`（PowerShell プロファイル） | ❌ | ✅ |
| `.config/wezterm`（Windows 版 WezTerm 設定） | ❌ | ✅ |

> Windows は PowerShell プロファイルを `~/Documents` 配下に置く仕様のため、`Documents/` 配下が Windows 専用になっている。

## 日常運用

| やりたいこと | コマンド |
|---|---|
| 管理対象ファイルを編集 | `chezmoi edit ~/.bashrc` |
| ホームで直接編集した内容をソースへ取り込み | `chezmoi re-add` |
| 新しいファイルを管理対象に追加 | `chezmoi add ~/.config/foo/bar` |
| ソースとホームの差分を確認 | `chezmoi diff` |
| ソースの変更をホームへ適用 | `chezmoi apply` |
| ソースリポジトリへ移動 | `chezmoi cd` |
| コミット & プッシュ | `chezmoi cd` → `git add -A && git commit && git push` |
| 別マシンの変更を取り込み（pull + apply） | `chezmoi update` |

## ソースの命名規則（chezmoi）

| ソース上の名前 | 展開先 / 意味 |
|---|---|
| `dot_bashrc` | `~/.bashrc` |
| `private_dot_config/` | `~/.config/`（パーミッション 600/700） |
| `*.tmpl` | テンプレート（`.chezmoi.toml.tmpl` の値などを差し込む） |
