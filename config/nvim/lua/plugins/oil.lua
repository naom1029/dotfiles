-- oil.nvim
-- ディレクトリをバッファとして編集できるファイルマネージャー
-- Vimのコマンドでファイル操作が可能（dd で削除、yy でコピーなど）

return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
    { '<leader>o', '<cmd>Oil .<cr>', desc = '[O]pen current directory' },
  },
  opts = {
    -- デフォルトのファイルエクスプローラーとして設定
    default_file_explorer = false, -- neo-tree と共存するため false に設定

    -- カラムの設定
    columns = {
      'icon',
      -- 'permissions',
      -- 'size',
      -- 'mtime',
    },

    -- バッファ設定
    buf_options = {
      buflisted = false,
      bufhidden = 'hide',
    },

    -- ウィンドウ設定
    win_options = {
      wrap = false,
      signcolumn = 'no',
      cursorcolumn = false,
      foldcolumn = '0',
      spell = false,
      list = false,
      conceallevel = 3,
      concealcursor = 'nvic',
    },

    -- 削除時の確認
    delete_to_trash = false,
    skip_confirm_for_simple_edits = false,

    -- プレビューウィンドウ
    preview = {
      -- プレビューを有効化
      max_width = 0.9,
      min_width = { 40, 0.4 },
      width = nil,
      max_height = 0.9,
      min_height = { 5, 0.1 },
      height = nil,
      border = 'rounded',
      win_options = {
        winblend = 0,
      },
    },

    -- プログレス表示
    progress = {
      max_width = 0.9,
      min_width = { 40, 0.4 },
      width = nil,
      max_height = { 10, 0.9 },
      min_height = { 5, 0.1 },
      height = nil,
      border = 'rounded',
      minimized_border = 'none',
      win_options = {
        winblend = 0,
      },
    },

    -- キーマップ（oil.nvim バッファ内でのみ有効）
    keymaps = {
      ['g?'] = 'actions.show_help',
      ['<CR>'] = 'actions.select',
      ['<C-s>'] = 'actions.select_vsplit',
      ['<C-h>'] = false, -- グローバルキーマップと競合しないように無効化
      ['<C-t>'] = 'actions.select_tab',
      ['<C-p>'] = 'actions.preview',
      ['<C-c>'] = 'actions.close',
      ['<C-l>'] = false, -- グローバルキーマップと競合しないように無効化
      ['-'] = 'actions.parent',
      ['_'] = 'actions.open_cwd',
      ['`'] = 'actions.cd',
      ['~'] = 'actions.tcd',
      ['gs'] = 'actions.change_sort',
      ['gx'] = 'actions.open_external',
      ['g.'] = 'actions.toggle_hidden',
      ['g\\'] = 'actions.toggle_trash',
    },

    -- 隠しファイルの表示
    view_options = {
      show_hidden = false,
      is_hidden_file = function(name, bufnr)
        return vim.startswith(name, '.')
      end,
      is_always_hidden = function(name, bufnr)
        return false
      end,
    },

    -- Git統合
    -- git status に基づいてファイルをハイライト
    -- gitsigns.nvim と連携
    use_default_keymaps = true,
  },
}
