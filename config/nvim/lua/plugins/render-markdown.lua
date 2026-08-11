-- render-markdown.nvim
-- Markdownをバッファ内でリッチに描画

return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  init = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function(event)
        vim.keymap.set('n', '<leader>um', '<cmd>RenderMarkdown toggle<cr>', {
          buf = event.buf,
          desc = '[U]I: Toggle Render [M]arkdown',
        })
      end,
    })
  end,
  opts = {},
}
