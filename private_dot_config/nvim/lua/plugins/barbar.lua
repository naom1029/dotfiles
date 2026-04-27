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

    -- バッファ間の移動（<leader>b + h/l）
    map('n', '<leader>bh', '<cmd>BufferPrevious<cr>', { desc = 'Previous buffer' })
    map('n', '<leader>bl', '<cmd>BufferNext<cr>', { desc = 'Next buffer' })

    -- バッファの並び替え
    map('n', '<leader>bH', '<cmd>BufferMovePrevious<cr>', { desc = 'Move buffer left' })
    map('n', '<leader>bL', '<cmd>BufferMoveNext<cr>', { desc = 'Move buffer right' })

    -- 特定のバッファへジャンプ（<leader> + 数字）
    map('n', '<leader>1', '<cmd>BufferGoto 1<cr>', { desc = 'Goto buffer 1' })
    map('n', '<leader>2', '<cmd>BufferGoto 2<cr>', { desc = 'Goto buffer 2' })
    map('n', '<leader>3', '<cmd>BufferGoto 3<cr>', { desc = 'Goto buffer 3' })
    map('n', '<leader>4', '<cmd>BufferGoto 4<cr>', { desc = 'Goto buffer 4' })
    map('n', '<leader>5', '<cmd>BufferGoto 5<cr>', { desc = 'Goto buffer 5' })
    map('n', '<leader>6', '<cmd>BufferGoto 6<cr>', { desc = 'Goto buffer 6' })
    map('n', '<leader>7', '<cmd>BufferGoto 7<cr>', { desc = 'Goto buffer 7' })
    map('n', '<leader>8', '<cmd>BufferGoto 8<cr>', { desc = 'Goto buffer 8' })
    map('n', '<leader>9', '<cmd>BufferGoto 9<cr>', { desc = 'Goto buffer 9' })
    map('n', '<leader>0', '<cmd>BufferLast<cr>', { desc = 'Goto last buffer' })

    -- バッファを閉じる
    map('n', '<leader>bc', '<cmd>BufferClose<cr>', { desc = 'Close buffer' })
    map('n', '<leader>bo', '<cmd>BufferCloseAllButCurrent<cr>', { desc = 'Close all but current (Only)' })

    -- バッファのピン留め
    map('n', '<leader>bP', '<cmd>BufferPin<cr>', { desc = 'Pin/Unpin buffer' })

    -- バッファピッカー（インタラクティブ選択）
    map('n', '<leader>bp', '<cmd>BufferPick<cr>', { desc = 'Buffer pick' })
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
