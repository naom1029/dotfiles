# Neovim Configuration

モジュール化された個人用 Neovim 設定

## 概要

- **プラグインマネージャー**: lazy.nvim
- **リーダーキー**: スペース (`<leader>` = ` `)
- **構造**: モジュール化された設定ファイル

## ディレクトリ構造

```
~/.config/nvim/
├── init.lua          # エントリーポイント（最小限）
├── lazy-lock.json   # プラグインのバージョンロック
├── lua/
│   ├── config/      # 基本設定（options, keymaps, autocmds, lazy）
│   └── plugins/     # プラグイン設定（各ファイルが1プラグイン）
├── README.md        # このファイル
└── CLAUDE.md       # Claude Code用メンテナンス指示
```

## インストール済みプラグイン

### コード補完

| プラグイン          | 説明               | 主要コマンド/キーマップ                                                            |
| ------------------- | ------------------ | ---------------------------------------------------------------------------------- |
| nvim-cmp            | 自動補完エンジン   | `<C-Space>` - 補完メニュー<br>`<C-n/p>` - 候補選択                                 |
| LuaSnip             | スニペットエンジン | `<C-l>` - 次の位置へ<br>`<C-h>` - 前の位置へ                                       |
| nvim-autopairs      | 括弧/クォート補完  | 自動有効                                                                          |

### LSP・言語サポート

| プラグイン      | 説明                    | 主要コマンド/キーマップ                                    |
| --------------- | ----------------------- | ---------------------------------------------------------- |
| nvim-lspconfig  | LSP 基本設定            | `gd` - 定義ジャンプ<br>`gr` - 参照検索<br>`K` - ホバー情報 |
| mason.nvim      | LSP サーバー管理        | `:Mason` - 管理 UI                                         |
| nvim-treesitter | 構文解析・ハイライト    | 自動有効                                                   |
| nvim-ts-autotag | HTML/JSX タグ自動閉じ   | 自動有効                                                   |
| conform.nvim    | フォーマッター          | `<leader>cf` - フォーマット                                |
| lazydev.nvim    | Neovim Lua 開発サポート | 自動有効                                                   |
| nvim-treesitter-context | 関数/クラスのコンテキスト固定表示 | `<leader>uc` - トグル                          |
| aerial.nvim | シンボルアウトライン    | `<leader>cs` - トグル<br>`]a/[a` - シンボル移動            |
| trouble.nvim | 診断/quickfix リスト UI | `<leader>xx` - 診断リスト（他 `<leader>x` 系）           |
| ts-error-translator.nvim | TS エラーを平易に翻訳 | 自動有効                                             |

**対応言語サーバー:**
- Lua (lua_ls)
- TypeScript/JavaScript (ts_ls)
- JSON (jsonls)
- Python (pyright)
- C/C++ (clangd)

### デバッグ

| プラグイン                | 説明                   | 主要コマンド/キーマップ                                                                                      |
| ------------------------- | ---------------------- | ------------------------------------------------------------------------------------------------------------ |
| nvim-dap              | デバッグアダプタープロトコル | `<F5>` - デバッグ開始/継続<br>`<F10>` - ステップオーバー<br>`<leader>db` - ブレイクポイントトグル           |
| nvim-dap-ui           | デバッグUI             | `<leader>du` - UIトグル<br>`<leader>de` - 式評価                                                            |
| nvim-dap-virtual-text     | デバッグ情報仮想テキスト表示 | 自動有効                                                                                                     |
| vscode-js-debug (Mason)   | JavaScript/TypeScript デバッガー | `js-debug-adapter` を nvim-dap に直接登録（接着剤プラグイン不使用）                                    |

**対応言語:**
- JavaScript/TypeScript (vscode-js-debug / Mason: `js-debug-adapter`)
  - 単純な `.ts`/`.js`: "Launch file (Node, native TS)"
  - import を含む実プロジェクト: "Launch file (tsx)"（要 `tsx`）
- C/C++ (codelldb)
- Rust (codelldb)

### ファイル・検索

| プラグイン     | 説明                           | 主要コマンド/キーマップ                                                                  |
| -------------- | ------------------------------ | ---------------------------------------------------------------------------------------- |
| telescope.nvim | ファジーファインダー           | `<leader>sf` - ファイル検索<br>`<leader>sg` - grep 検索<br>`<leader><leader>` - バッファ |
| neo-tree.nvim  | ファイルエクスプローラー       | `\` - 開閉トグル                                                                         |
| oil.nvim   | バッファ型ファイルマネージャー | `-` - 親ディレクトリを開く<br>`<leader>o` - カレントディレクトリを開く                   |

### Git 連携

| プラグイン          | 説明                   | 主要コマンド/キーマップ                                                                                                                      |
| ------------------- | ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| gitsigns.nvim       | Git 差分表示・操作     | `<leader>gd` - diff<br>`<leader>gb` - blame<br>`<leader>gp` - preview<br>`]h/[h` - hunk移動 |
| lazygit.nvim        | LazyGit TUI 統合       | `<leader>gl` - LazyGit 起動<br>`<leader>gc` - 設定画面<br>`<leader>gf` - 現在のファイル                                                    |
| git-worktree.nvim   | Git worktree 管理      | `<leader>wl` - 一覧・切り替え<br>`<leader>wc` - 新規作成                                                                                    |
| diffview.nvim       | Git diff/履歴ビューア  | `<leader>gD` - プロジェクト diff<br>`<leader>gH` - ファイル履歴 |

### UI・表示

| プラグイン            | 説明                           | 主要コマンド/キーマップ                                 |
| --------------------- | ------------------------------ | ------------------------------------------------------- |
| kanagawa.nvim         | カラースキーム                 | 自動適用 (kanagawa-dragon)                              |
| barbar.nvim       | タブライン風バッファライン     | `<leader>bn/bp` - 次/前のバッファ<br>`<leader>bb` - 選択(pick) |
| nvim-web-devicons     | ファイルアイコン表示           | 自動有効                                                |
| which-key.nvim        | キーバインドガイド             | キー押下で自動表示                                      |
| lualine.nvim          | ステータスライン               | 自動表示                                                |
| todo-comments.nvim    | TODO/FIXME ハイライト          | 自動ハイライト<br>`]t/[t` - 次/前の TODO へ             |
| indent-blankline.nvim | インデントガイド（レインボー） | 自動表示                                                |

### ユーティリティ

| プラグイン        | 説明                           | 主要コマンド/キーマップ                                                                      |
| ----------------- | ------------------------------ | -------------------------------------------------------------------------------------------- |
| snacks.nvim       | QoL 機能の詰め合わせ           | `<leader>.` - ダッシュボード<br>`]r`/`[r` - 同一シンボル参照へジャンプ（words）<br>その他: terminal, bigfile, quickfile, scroll, rename(neo-tree/oil 連携) を有効化 |
| mini.nvim         | 多機能ユーティリティ           | textobjects、statusline 等                                                                   |
| nvim-surround     | テキスト囲み操作               | `ys{motion}{char}` - 囲む<br>`ds{char}` - 削除<br>`cs{old}{new}` - 変更                      |
| toggleterm.nvim   | ターミナルトグル               | `<C-\>` - トグル（下部）<br>`<leader>tf` - フローティング<br>`<leader>th/tv` - 水平/垂直分割 |
| memo.nvim     | シンプルなメモ管理             | `<leader>mn` - 新規メモ<br>`<leader>mm` - メモ検索<br>`<leader>md` - 今日の予実メモ              |
| nvim-rooter   | 自動プロジェクトルート検出     | 自動有効（ファイル開くと git root に cd）                                                    |
| flash.nvim    | ラベルジャンプ | `s` - ジャンプ<br>`S` - Treesitter 選択                                                  |
| dressing.nvim     | 入力/選択 UI の改善            | 自動有効（vim.ui.input/select を装飾）                                                       |
| auto-session  | セッション自動保存/復元        | 自動有効<br>`<leader>ps` - セッション検索<br>`<leader>pd` - セッション削除                   |
| hardtime.nvim | Vim効率化トレーニング          | 自動有効（非効率な操作を制限）                                                               |
| vim-sleuth        | インデント自動検出             | 自動有効                                                                                     |

### Markdown

| プラグイン              | 説明                           | 主要コマンド/キーマップ                          |
| ----------------------- | ------------------------------ | ------------------------------------------------ |
| markdown-preview.nvim   | Markdown ブラウザプレビュー    | `<leader>cp` - プレビュートグル                  |
| render-markdown.nvim | Markdown バッファ内リッチ描画 | `<leader>um` - 描画トグル                        |

## キーマップ

### グローバルキーマップ

グローバルキーマップの詳細は `lua/config/keymaps.lua` を参照してください。

- **リーダーキー**: スペース (`<leader>` = ` `)
- **主要操作**: ウィンドウ移動、分割、保存、バッファ操作、インデント調整など

### プラグイン固有のキーマップ

プラグインごとのキーマップは各プラグイン設定ファイル（`lua/plugins/*.lua`）に定義されています。

#### ファイルエクスプローラー (Neo-tree)

- `\` - Neo-tree 開閉

#### バッファ型ファイルマネージャー (Oil)

- `-` - 親ディレクトリを開く
- `<leader>o` - カレントディレクトリを開く

**Oil バッファ内のキーマップ:**

- `<CR>` - ファイル/ディレクトリを開く
- `<C-s>` - 垂直分割で開く
- `<C-t>` - タブで開く
- `<C-p>` - プレビュー
- `<C-c>` - 閉じる
- `-` - 親ディレクトリに移動
- `_` - カレントディレクトリに移動
- `g.` - 隠しファイルをトグル
- `g?` - ヘルプを表示

#### ファジーファインダー (Telescope)

- `<leader>sf` - ファイル検索
- `<leader>sg` - テキスト検索 (grep)
- `<leader>st` - Telescope builtin 選択
- `<leader>so` - 最近開いたファイル検索
- `<leader><leader>` - 開いているバッファ検索
- `<leader>sn` - Neovim 設定ファイル検索

#### バッファライン (barbar.nvim)

- `<leader>bn` / `<leader>bp` - 次/前のバッファへ移動
- `<leader>bH` / `<leader>bL` - バッファの順序を左/右に移動
- `<leader>bb` - バッファ選択（文字ラベルで直接ジャンプ・数字ジャンプの代替）
- `<leader>bc` - 現在のバッファを閉じる
- `<leader>bo` - 現在以外のすべてのバッファを閉じる
- `<leader>bP` - バッファをピン留め/解除
- `<leader>bd` - バッファ削除（レイアウト保持・snacks.bufdelete）

#### LSP・コード編集

**移動 (goto)：**
- `gd` - 定義へジャンプ
- `gr` - 参照一覧
- `gI` - 実装へジャンプ
- `gD` - 宣言へジャンプ
- `gy` - 型定義へジャンプ
- `<leader>sd` - ドキュメントシンボル検索（Search）

**コードアクション ([C]ode グループ・LazyVim 準拠)：**
- `<leader>ca` - コードアクション
- `<leader>cr` - リネーム（LSP 標準、旧 `<leader>rn`）
- `<leader>cf` - コードフォーマット
- `<leader>cw` - ワークスペースシンボル検索
- `<leader>cs` - シンボルアウトライン（aerial）

**UI トグル ([U]I グループ)：**
- `<leader>uh` - Inlay Hints トグル
- `<leader>uc` - Treesitter Context トグル
- `<leader>um` - Markdown 描画トグル（render-markdown）

#### 診断・quickfix (trouble.nvim)

- `<leader>xx` - 全診断リスト
- `<leader>xX` - 現在バッファの診断
- `<leader>xl` - LSP 定義/参照リスト
- `<leader>xs` - シンボルリスト
- `<leader>xL` - Location list
- `<leader>xQ` - Quickfix list
- `<leader>xt` - TODO 一覧
- `<leader>e` - 現在行の診断を float 表示（標準）
- `<leader>sD` - 診断をあいまい検索（telescope）

#### 移動 (`[` / `]` プレフィックス)

- `]d` / `[d` - 次/前の診断へ
- `]h` / `[h` - 次/前の git hunk へ
- `]a` / `[a` - 次/前のシンボルへ（aerial）
- `]t` / `[t` - 次/前の TODO コメントへ
- `]r` / `[r` - 次/前の同一シンボル参照へ（snacks words）
- `]]` / `[[`・`][` / `[]` - 次/前の関数・セクションへ（Vim 標準）
- `%` - 対応する括弧へジャンプ（Vim 標準）

#### デバッグ (DAP)

**デバッグ実行:**
- `<F5>` - デバッグ開始/継続
- `<leader>dc` - デバッグ継続
- `<leader>dt` - デバッグ終了

**ブレイクポイント:**
- `<leader>db` - ブレイクポイントのトグル
- `<leader>dB` - 条件付きブレイクポイントを設定

**ステップ実行:**
- `<F10>` - ステップオーバー
- `<F11>` - ステップイン
- `<F12>` - ステップアウト
- `<leader>dso` - ステップオーバー（代替）
- `<leader>dsi` - ステップイン（代替）
- `<leader>dsO` - ステップアウト（代替）

**UI操作:**
- `<leader>du` - デバッグUIのトグル
- `<leader>de` - 式の評価（ノーマル/ビジュアルモード）

**プロジェクト固有のデバッグ設定:**

プロジェクトルートに `.vscode/launch.json` または `.nvim.lua` を配置すると、プロジェクト固有のデバッグ設定を使用できます。
詳細は `lua/plugins/dap/cpp.lua` のコメントを参照。

#### Markdown

- `<leader>cp` - Markdown ブラウザプレビューのトグル (markdown-preview)
- `<leader>um` - Markdown バッファ内描画のトグル (render-markdown)

#### テキスト操作 (nvim-surround)

- `ys{motion}{char}` - テキストを囲む（例: `ysiw"` で単語をダブルクォートで囲む）
- `ds{char}` - 囲みを削除（例: `ds"` でダブルクォートを削除）
- `cs{old}{new}` - 囲みを変更（例: `cs"'` でダブルクォートをシングルクォートに）

#### ターミナル (toggleterm.nvim)

- `<C-\>` - ターミナルをトグル（デフォルト: 下部）
- `<leader>tf` - フローティングターミナルを開く
- `<leader>th` - 水平分割でターミナルを開く
- `<leader>tv` - 垂直分割でターミナルを開く

#### メモ管理 (memo.nvim)

- `<leader>mn` - 新規メモを作成（カテゴリ選択 → タイムスタンプ形式ファイル）
- `<leader>mm` - メモをファイル名で検索（サブディレクトリ含む）
- `<leader>mg` - メモを内容でgrep検索
- `<leader>md` - 今日の予実メモを開く（日次1ファイル。無ければ予定/実績テンプレ付きで作成）

**カテゴリ:** work, personal, idea（`~/.memo/{category}/` に保存）

**予実メモ:** `~/.memo/daily/YYYY-MM-DD.md`（1日1ファイル）。`:MemoToday` コマンドでも開ける。シェルから一発で開きたい場合は `~/.bashrc` に `alias memo='nvim +MemoToday'` を追加。

### Git 操作

#### Gitsigns

**Hunk ナビゲーション:**
- `]h` - 次の hunk へジャンプ
- `[h` - 前の hunk へジャンプ

**Hunk 操作:**
- `<leader>gs` - Hunk をステージ（ノーマル/ビジュアル）
- `<leader>gr` - Hunk をリセット（ノーマル/ビジュアル）
- `<leader>gS` - バッファ全体をステージ
- `<leader>gR` - バッファ全体をリセット

**プレビュー・情報:**
- `<leader>gp` - Hunk をプレビュー
- `<leader>gi` - Hunk をインライン表示
- `<leader>gb` - 現在の行の blame 情報を表示

**Diff:**
- `<leader>gd` - 現在のファイルの diff を表示

#### Diffview

- `<leader>gD` - Diffview トグル（プロジェクト全体の diff）
- `<leader>gH` - 現在のファイルの履歴を表示

#### LazyGit

- `<leader>gl` - LazyGit 起動
- `<leader>gc` - LazyGit 設定
- `<leader>gf` - 現在のファイルで LazyGit

#### Git Worktree

- `<leader>wl` - Worktree 一覧・切り替え（Telescope）
- `<leader>wc` - 新しい Worktree を作成（Telescope）

## トラブルシューティング

### プラグインエラー

1. `:checkhealth` でヘルスチェック実行
2. `:Lazy` でプラグイン状態確認
3. 必要に応じて `:Lazy clean` → `:Lazy sync`

### LSP が動作しない

1. `:Mason` で LSP サーバーがインストールされているか確認
2. `:LspInfo` で LSP の状態確認
3. `lua/plugins/lsp.lua` でサーバー設定を確認
