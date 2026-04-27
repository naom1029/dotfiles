-- lazydev.nvim
-- Neovim設定、ランタイム、プラグインのLua LSP設定

return {
  'folke/lazydev.nvim',
  ft = 'lua',
  opts = {
    library = {
      -- vim.uvが見つかった場合にluvitタイプをロード
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  },
}
