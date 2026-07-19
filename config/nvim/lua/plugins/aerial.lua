-- aerial.nvim
-- コードのシンボルアウトライン（関数/クラス/interface 等をサイドバーにツリー表示）。
-- LSP または treesitter からシンボルを抽出するため、対応言語なら全般で動作する。

return {
  'stevearc/aerial.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  cmd = { 'AerialToggle', 'AerialOpen', 'AerialNavToggle' },
  keys = {
    { '<leader>cs', '<cmd>AerialToggle<cr>', desc = '[C]ode [S]ymbols outline (aerial)' },
    { ']a', '<cmd>AerialNext<cr>', desc = '次のシンボルへ (aerial)' },
    { '[a', '<cmd>AerialPrev<cr>', desc = '前のシンボルへ (aerial)' },
  },
  opts = {
    -- lsp を優先し、無ければ treesitter → markdown → man の順で使用
    backends = { 'lsp', 'treesitter', 'markdown', 'man' },
    layout = {
      min_width = 28,
      default_direction = 'right',
    },
    show_guides = true,
    -- カーソル位置のシンボルを常にハイライト
    highlight_on_hover = true,
  },
}
