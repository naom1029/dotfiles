-- hardtime.nvim
-- Vim の非効率な操作を防ぎ、より効率的な使い方を学習するためのプラグイン

return {
  'm4xshen/hardtime.nvim',
  dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
  event = 'VeryLazy',
  opts = {
    -- デフォルトで有効化
    enabled = true,
    -- 制限する最大回数（例: hjklを3回連続で押すと警告）
    max_count = 3,
    -- 制限時間（ミリ秒）
    max_time = 1000,
    -- 無効化するファイルタイプ
    disabled_filetypes = { 'qf', 'netrw', 'lazy', 'mason', 'oil' },
    -- ヒント表示
    hint = true,
    -- 制限するキー
    restriction_mode = 'block',
  },
}
