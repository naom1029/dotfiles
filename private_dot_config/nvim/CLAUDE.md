# CLAUDE.md

Claude Code 用 Neovim 設定メンテナンス指示書

## このファイルの目的

このファイルは、Claude Code がこの Neovim 設定を理解し、適切にメンテナンスするためのガイドラインです。

## 重要な情報

### 環境

- **設定スタイル**: モジュール化された独自設定
- **プラグインマネージャー**: lazy.nvim

### ディレクトリ構造

```
nvim/
├── init.lua                # エントリーポイント（最小限）
├── lazy-lock.json         # プラグインバージョン管理
├── lua/
│   ├── config/            # 基本設定
│   │   ├── options.lua    # Vimオプション
│   │   ├── keymaps.lua    # キーマップ
│   │   ├── autocmds.lua   # Autocommands
│   │   └── lazy.lua       # lazy.nvim初期化
│   └── plugins/           # プラグイン設定（各ファイルが1プラグイン）
│       ├── lsp.lua        # LSP + Mason
│       ├── cmp.lua        # 補完
│       ├── telescope.lua  # ファジーファインダー
│       ├── treesitter.lua # シンタックスハイライト
│       ├── colorscheme.lua# カラースキーム
│       ├── which-key.lua  # キーバインドガイド
│       ├── gitsigns.lua   # Git統合
│       ├── conform.lua    # フォーマッター
│       ├── lazydev.lua    # Lua開発サポート
│       ├── mini.lua       # ユーティリティ
│       ├── todo-comments.lua # TODOハイライト
│       ├── sleuth.lua     # インデント検出
│       ├── neo-tree.lua   # ファイルエクスプローラー
│       ├── lazygit.lua    # Git TUI
│       ├── claudecode.lua # Claude Code統合
│       └── snacks.lua     # ターミナル機能
├── README.md              # ユーザー向けドキュメント
└── CLAUDE.md             # このファイル
```

## 設計原則

### 1. モジュール化

- **1 ファイル = 1 責任**: 各設定ファイルは単一の責任を持つ
- **プラグインの分離**: 各プラグインは独立したファイルに配置
- **設定の分離**: options, keymaps, autocmds は別ファイルで管理

### 2. 可読性

- **明確な命名**: ファイル名はその内容を明確に表す
- **コメント**: 各ファイルに目的と機能を記述
- **構造の一貫性**: 全ファイルで統一された構造

### 3. メンテナンス性

- **変更の局所化**: 変更は該当ファイルのみで完結
- **依存関係の明示**: プラグインの依存関係を明確に記述
- **バックアップの保持**: 重要な変更前にバックアップを作成

## メンテナンスルール

### 1. README.md の更新

**必ず更新する場合：**

- プラグインの追加・削除時
- プラグイン固有のキーマップの変更時
- 設定構造の変更時
- LSP サーバーの追加時

**更新箇所：**

- インストール済みプラグインセクション
- プラグイン固有のキーマップセクション
- ディレクトリ構造（変更があれば）

**重要なルール：**

- **グローバルキーマップ**（`lua/config/keymaps.lua`に定義）は、README.md に詳細を記載しない
  - 理由: 設定ファイルを見れば分かるため冗長
  - README.md には「詳細は `lua/config/keymaps.lua` を参照」と記載するのみ
- **プラグイン固有のキーマップ**（`lua/plugins/*.lua`に定義）は、README.md に記載する
  - 理由: プラグインごとに分散しているため、一覧性が重要

### 2. プラグイン追加時の手順

1. `lua/plugins/`に新しい Lua ファイルを作成
   - ファイル名: プラグイン名をわかりやすく（例: `telescope.lua`, `lsp.lua`）
2. プラグイン設定を記述（下記テンプレート参照）
3. README.md のプラグイン一覧を更新
4. プラグイン固有のキーマップがある場合は、README.md のプラグイン固有キーマップセクションも更新
   - 注: グローバルキーマップ（`lua/config/keymaps.lua`）を追加した場合は README.md への詳細記載は不要

**テンプレート例：**

```lua
-- プラグイン名
-- 簡単な説明

return {
  'author/plugin-name',
  dependencies = { 'dependency/name' },  -- 必要な場合
  event = 'VimEnter',  -- 遅延読み込みする場合
  keys = {
    { '<leader>xx', '<cmd>Command<cr>', desc = 'Description' },
  },
  config = function()
    require('plugin-name').setup({
      -- 設定内容
    })
  end,
}
```

### 3. プラグイン削除時の手順

1. README.md から該当プラグインの記述を削除
2. `:Lazy clean` で未使用プラグインを削除

### 4. 基本設定変更時のガイドライン

**ファイルごとの責任範囲：**

- `lua/config/options.lua`: Vim オプション（`vim.opt.*`）のみ
- `lua/config/keymaps.lua`: グローバルキーマップのみ（プラグイン固有のものは各プラグインファイル内に）
- `lua/config/autocmds.lua`: オートコマンドのみ
- `lua/config/lazy.lua`: lazy.nvim の bootstrap と初期化のみ（プラグイン定義は含まない）

**変更してはいけないもの：**

- `vim.g.mapleader` （init.lua で設定済み）
- `vim.g.maplocalleader` （init.lua で設定済み）
- lazy.nvim の bootstrap 構造（`lua/config/lazy.lua`）

**変更可能なもの：**

- Vim オプション（`lua/config/options.lua`）
- グローバルキーマップ（`lua/config/keymaps.lua`）
- プラグイン設定（`lua/plugins/`の各ファイル）
- LSP サーバー（`lua/plugins/lsp.lua`）

**キーマップの命名規則：**

- **小文字・大文字の使い分け**: スコープが大きい機能には大文字を使用
  - 小文字: ファイル単体やバッファ単体に限定される操作
  - 大文字: プロジェクト全体やワークスペース全体に影響する操作
  - 例:
    - `<leader>gd`: 現在のファイルのdiff（gitsigns）
    - `<leader>gD`: プロジェクト全体のdiff（diffview）
    - `<leader>sd`: 現在のドキュメントのシンボル検索（LSP）
    - `<leader>sD`: プロジェクト全体の診断検索（Telescope）
- **キーマップの競合確認**: 新しいキーマップを追加する際は、必ず既存のキーマップと競合しないか確認すること
- **which-key グループ**: `<leader>` プレフィックスで複数のキーマップがある場合は、which-key.lua にグループ定義を追加すること

### 5. LSP サーバーの追加

`lua/plugins/lsp.lua` の `servers` テーブルを編集：

```lua
local servers = {
  lua_ls = { ... },  -- 既存
  -- 新しいサーバーを追加
  pyright = {},
  ts_ls = {},
}
```

自動インストールするツール（フォーマッターなど）は `ensure_installed` に追加：

```lua
vim.list_extend(ensure_installed, {
  'stylua',  -- 既存
  'black',   -- 新規追加例
})
```

### 6. トラブルシューティング

**プラグインエラー時：**

1. エラーメッセージを確認
2. `:Lazy` でプラグイン状態確認
3. `:checkhealth lazy` で Lazy の健全性確認
4. 必要に応じて `:Lazy clean` → `:Lazy sync`

**設定エラー時：**

1. `:checkhealth` でヘルスチェック実行
2. エラーが出ているファイルを特定
3. 該当ファイルを修正またはバックアップから復元

**LSP 関連：**

1. `:Mason` で LSP サーバーの状態確認
2. `:LspInfo` で現在のバッファの LSP 状態確認
3. `lua/plugins/lsp.lua` の設定を確認

## バージョン管理

- `lazy-lock.json` でプラグインバージョンを固定
- 更新は `:Lazy update` で実行
- 問題が発生した場合は `git` で `lazy-lock.json` を復元可能

### コミットメッセージのガイドライン

**重要**: コミットメッセージには、変更したプラグインや設定ファイルを明記すること

**フォーマット：**

```
<type>(<scope>): <subject>

<body>

```

**type（種類）：**

- `feat`: 新機能追加
- `fix`: バグ修正
- `refactor`: リファクタリング
- `docs`: ドキュメント変更
- `chore`: その他の変更

**scope（対象範囲）：**

- プラグイン設定を変更した場合: プラグイン名（例: `cmp`, `lsp`, `telescope`）
- 基本設定を変更した場合: ファイル名（例: `options`, `keymaps`, `autocmds`）
- 複数ファイルにまたがる場合: 主要な変更箇所

**例：**

```
feat(cmp): Tabキーで補完を受け入れるように変更
fix(lsp): tsserverの設定を修正
feat(telescope): プレビュー機能を追加
refactor(keymaps): キーマップを整理
```

**理由：** 後からログを見た時に、どのプラグインの設定を変更したのか一目で分かるようにするため
