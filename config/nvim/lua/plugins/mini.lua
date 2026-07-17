-- mini.nvim
-- 小さな独立したプラグインのコレクション

return {
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    -- 例: va) - [V]isually select [A]round [)]paren
    --     yinq - [Y]ank [I]nside [N]ext [Q]uote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    -- 例: saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    --     sd' - [S]urround [D]elete [']quotes
    --     sr)' - [S]urround [R]eplace [)] [']
    -- NOTE: nvim-surroundを使用するため無効化
    -- require('mini.surround').setup()

    -- ステータスラインは lualine.nvim に移行済み
  end,
}
