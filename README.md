# dotfiles

[Nix](https://nixos.org/) + [home-manager](https://github.com/nix-community/home-manager) で管理する個人 dotfiles。

## セットアップ（新しいマシン）

### 1. Nix のインストール

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. dotfiles の取得と適用

```sh
git clone https://github.com/naom1029/dotfiles.git ~/.local/share/chezmoi
cd ~/.local/share/chezmoi
nix run nixpkgs#home-manager -- switch --flake .#naom1029
```

## リポジトリ構成

```
dotfiles/
├── flake.nix                    # Nixフレークのエントリポイント
├── flake.lock                   # 依存のロックファイル
├── home.nix                     # home-managerのルート（importsのみ）
├── nix/programs/                # プログラム別のNix設定
│   ├── bash.nix                 # bash + readline
│   ├── git.nix                  # git + delta + gh
│   ├── herdr.nix                # herdr (AIエージェントマルチプレクサ)
│   ├── lazygit.nix              # lazygit
│   ├── neovim.nix               # neovim
│   ├── tmux.nix                 # tmux + plugins
│   ├── tools.nix                # fzf, ripgrep, fd, bat, eza, etc.
│   └── wezterm.nix              # wezterm
└── config/                      # 設定ファイル（source参照で配置）
    ├── nvim/                    # Neovim lua設定
    ├── wezterm/                 # WezTerm lua設定
    ├── herdr/config.toml        # herdr設定
    ├── tmux/cheatsheet.md       # tmuxチートシート
    ├── gh-dash/config.yml       # gh-dash設定
    ├── ccstatusline/settings.json
    └── powershell/              # Windows PowerShellプロファイル
```

## 管理パッケージ一覧

### programs.* モジュール管理
git, delta, gh, fzf, tmux, lazygit, neovim, bash, readline

### パッケージ管理
ripgrep, fd, bat, eza, jq, tree, dust, trash-cli, vivid, zoxide, ghq, gh-dash, online-judge-tools, btop, lazydocker, herdr

### Nix管理外（専用マネージャで管理）
- **Rust**: rustup / cargo
- **Node.js**: volta (node, npm, pnpm)
- **npm tools**: ccstatusline, atcoder-cli

## 日常運用

| やりたいこと | コマンド |
|---|---|
| 設定を適用 | `nix run nixpkgs#home-manager -- switch --flake .#naom1029` |
| パッケージ追加 | `nix/programs/tools.nix` に追記して上記を実行 |
| flake入力を更新 | `nix flake update` |
| 差分確認 | `git diff` |
