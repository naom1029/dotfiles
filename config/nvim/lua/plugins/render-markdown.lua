-- render-markdown.nvim
-- Markdownをバッファ内でリッチに描画

return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { '<leader>um', '<cmd>RenderMarkdown toggle<cr>', desc = '[U]I: Toggle Render [M]arkdown' },
  },
  opts = {},
}
