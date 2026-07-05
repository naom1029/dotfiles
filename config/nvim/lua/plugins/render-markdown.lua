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
    { '<leader>tm', '<cmd>RenderMarkdown toggle<cr>', desc = '[T]oggle Render [M]arkdown' },
  },
  opts = {},
}
