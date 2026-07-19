-- barbar.nvim
-- タブライン風のバッファライン

return {
  'romgrk/barbar.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- アイコン表示
  },
  init = function()
    -- キーマップを設定
    local map = vim.keymap.set

    -- バッファ間の移動（n=next / p=previous）
    map('n', '<leader>bn', '<cmd>BufferNext<cr>', { desc = 'Next buffer' })
    map('n', '<leader>bp', '<cmd>BufferPrevious<cr>', { desc = 'Previous buffer' })

    -- バッファの並び替え（左右）
    map('n', '<leader>bH', '<cmd>BufferMovePrevious<cr>', { desc = 'Move buffer left' })
    map('n', '<leader>bL', '<cmd>BufferMoveNext<cr>', { desc = 'Move buffer right' })

    -- バッファ選択（文字ラベルでジャンプ・数字ジャンプの代替）
    map('n', '<leader>bb', '<cmd>BufferPick<cr>', { desc = 'Pick buffer' })

    -- バッファを閉じる
    map('n', '<leader>bc', '<cmd>BufferClose<cr>', { desc = 'Close buffer' })
    map('n', '<leader>bo', '<cmd>BufferCloseAllButCurrent<cr>', { desc = 'Close all but current (Only)' })

    -- バッファのピン留め
    map('n', '<leader>bP', '<cmd>BufferPin<cr>', { desc = 'Pin/Unpin buffer' })
  end,
  config = function()
    -- barbar.nvim をセットアップ
    require('barbar').setup {
      -- アニメーション有効化
      animation = true,

      -- アイコン設定
      icons = {
        buffer_index = false,
        buffer_number = false,
        button = '',
        diagnostics = {
          [vim.diagnostic.severity.ERROR] = { enabled = true },
          [vim.diagnostic.severity.WARN] = { enabled = true },
          [vim.diagnostic.severity.INFO] = { enabled = false },
          [vim.diagnostic.severity.HINT] = { enabled = false },
        },
        filetype = {
          enabled = true,
        },
        separator = { left = '▎', right = '' },
        modified = { button = '●' },
        pinned = { button = '📌' },
        preset = 'default',
        alternate = { filetype = { enabled = false } },
        current = { buffer_index = false },
        inactive = { button = '×' },
        visible = { modified = { buffer_number = false } },
      },

      -- タブページ表示
      tabpages = true,

      -- クリック可能
      clickable = true,

      -- Focus on close: previous または left/right
      focus_on_close = 'previous',

      -- バッファを閉じる際にウィンドウを非表示
      hide = { extensions = false, inactive = false },

      -- サイドバー（neo-tree等）のオフセット
      sidebar_filetypes = {
        ['neo-tree'] = { event = 'BufWipeout' },
      },

      -- 最大/最小バッファ名の長さ
      maximum_padding = 1,
      minimum_padding = 1,
      maximum_length = 30,
      minimum_length = 0,
    }
  end,
}
