-- todo-comments.nvim
-- TODO、NOTE、FIXMEなどのコメントをハイライト

return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    signs = false,
  },
}
