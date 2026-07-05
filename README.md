# dotfiles

[Nix](https://nixos.org/) + [home-manager](https://github.com/nix-community/home-manager) で管理する個人 dotfiles。

## クイックスタート

```sh
# 1. Nix をインストール
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 2. シェルを再起動
exec $SHELL

# 3. dotfiles を取得
git clone https://github.com/naom1029/dotfiles.git ~/src/github.com/naom1029/dotfiles
cd ~/src/github.com/naom1029/dotfiles

# 4. home-manager で適用
nix run nixpkgs#home-manager -- switch --flake . --impure -b bak
```

これだけで全ツール・全設定が一発で入ります。

> **Note**: ユーザー名は実行時の `$USER` から動的に解決するため `--impure` が必須です。
> ユーザー名がリポジトリにハードコードされていないので、任意の Linux ユーザーでそのまま使えます。

## リポジトリ構成

```
dotfiles/
├── flake.nix                    # Nixフレークのエントリポイント
├── flake.lock                   # 依存のロックファイル
├── home.nix                     # home-managerのルート（importsのみ）
├── nix/programs/                # プログラム別のNix設定
│   ├── bash.nix                 # bash + readline
│   ├── direnv.nix               # direnv + nix-direnv
│   ├── git.nix                  # git + delta + gh
│   ├── herdr.nix                # herdr (AIエージェントマルチプレクサ)
│   ├── lazygit.nix              # lazygit
│   ├── neovim.nix               # neovim
│   ├── tmux.nix                 # tmux + plugins
│   ├── tools.nix                # fzf, ripgrep, fd, bat, eza, uv, claude-code, etc.
│   └── wezterm.nix              # wezterm (Windows側に自動配置)
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
git, delta, gh, fzf, tmux, lazygit, neovim, bash, readline, direnv

### パッケージ管理
ripgrep, fd, bat, eza, jq, tree, dust, trash-cli, vivid, zoxide, ghq, gh-dash, online-judge-tools, btop, lazydocker, herdr, uv, pipx, claude-code

### Nix管理外（専用マネージャで管理）
- **Rust**: rustup / cargo
- **Node.js**: volta (node, npm, pnpm)
- **npm tools**: ccstatusline, atcoder-cli

## 日常運用

| やりたいこと | コマンド |
|---|---|
| 設定を適用 | `nix run nixpkgs#home-manager -- switch --flake . --impure` |
| パッケージ追加 | `nix/programs/tools.nix` に追記して上記を実行 |
| flake入力を更新 | `nix flake update` |
| 差分確認 | `git diff` |

## プロジェクト別の開発環境

direnv + nix-direnv でプロジェクトごとに自動切替：

```sh
# プロジェクトに flake.nix を作成（devShell定義）
# .envrc に以下を記述
echo "use flake" > .envrc
direnv allow

# 以降は cd するだけで環境が自動切替
```
