-- Options設定
-- Neovimの基本設定を管理

-- 文字コード設定
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- Nerd Font設定
vim.g.have_nerd_font = true

-- 行番号を表示
vim.opt.number = true
-- 相対行番号
vim.opt.relativenumber = true

-- マウスモード有効化
vim.opt.mouse = 'a'

-- モード表示を無効化（ステータスラインに表示されるため）
vim.opt.showmode = false

-- OSとNeovimのクリップボードを同期
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- インデントを改行時に維持
vim.opt.breakindent = true

-- Undo履歴を保存
vim.opt.undofile = true

-- 大文字小文字を区別しない検索（\Cまたは大文字が含まれる場合を除く）
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- サインカラムを常に表示
vim.opt.signcolumn = 'yes'

-- 更新時間を短縮（デフォルトは4000ms）
vim.opt.updatetime = 250

-- マップシーケンスの待ち時間を短縮
vim.opt.timeoutlen = 500

-- 新しい分割ウィンドウの位置
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 空白文字の表示設定
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- 置換のライブプレビュー
vim.opt.inccommand = 'split'

-- カーソル行をハイライト
vim.opt.cursorline = true

-- カーソルの上下に最低限保持する行数
vim.opt.scrolloff = 10

-- ターミナルでの24ビットカラーを有効化
vim.opt.termguicolors = true

-- 行を折り返して表示
vim.opt.wrap = true

-- タブをスペースに変換
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smarttab = true

-- 自動インデント
vim.opt.autoindent = true
vim.opt.smartindent = true

-- スワップファイルとバックアップを無効化
vim.opt.swapfile = false
vim.opt.backup = false

-- 補完メニューの設定
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.pumheight = 10

-- コマンドライン非表示（入力時のみ表示）
vim.opt.cmdheight = 0

-- 検索ハイライト
vim.opt.hlsearch = true

-- グローバルステータスライン（全ウィンドウ共通）
vim.opt.laststatus = 3

-- フローティングウィンドウの角丸ボーダー
vim.o.winborder = 'rounded'

-- 隠しバッファを有効化
vim.opt.hidden = true

-- マークダウンなどでの特殊文字表示レベル
vim.opt.conceallevel = 2

-- メッセージ表示の最適化
vim.opt.shortmess:append 'c'

-- ヘルプの言語設定（日本語優先）
vim.opt.helplang = { 'ja', 'en' }

-- タイトル表示を有効化
vim.opt.title = true

-- コマンドを表示
vim.opt.showcmd = true

-- プロジェクト固有設定ファイル (.nvim.lua) を有効化
vim.opt.exrc = true

-- LSP 診断表示設定
vim.diagnostic.config {
  -- 行末に診断メッセージを表示
  virtual_text = {
    spacing = 4,
    prefix = '●',
  },
  -- サイン（行番号の左）を表示とカスタマイズ（Neovim 0.11+）
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.HINT] = '',
      [vim.diagnostic.severity.INFO] = '',
    },
  },
  -- 下線を表示
  underline = true,
  -- 重要度でソート
  severity_sort = true,
  -- フローティングウィンドウの設定
  float = {
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  },
}
