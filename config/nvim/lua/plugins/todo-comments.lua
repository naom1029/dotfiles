-- todo-comments.nvim
-- TODO、NOTE、FIXMEなどのコメントをハイライト

return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    signs = false,
  },
  keys = {
    { ']t', function() require('todo-comments').jump_next() end, desc = '次の TODO コメントへ' },
    { '[t', function() require('todo-comments').jump_prev() end, desc = '前の TODO コメントへ' },
  },
}
