-- nvim-ts-autotag
-- Treesitter と連携して HTML/JSX タグを自動で閉じる

return {
  'windwp/nvim-ts-autotag',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  event = 'InsertEnter',
  config = function()
    require('nvim-ts-autotag').setup({
      opts = {
        enable_close = true, -- タグの自動閉じを有効化
        enable_rename = true, -- タグのリネームを有効化
        enable_close_on_slash = true, -- `/>`で自動閉じ
      },
    })
  end,
}
