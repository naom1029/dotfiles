-- nvim-surround
-- テキストを囲む・変更・削除する操作を提供

return {
  'kylechui/nvim-surround',
  version = '*',
  keys = {
    { 'ys', mode = 'n' },
    { 'ds', mode = 'n' },
    { 'cs', mode = 'n' },
    { 'S', mode = 'v' },
  },
  config = function()
    require('nvim-surround').setup({})
  end,
}
