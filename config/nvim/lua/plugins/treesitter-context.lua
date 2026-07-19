-- nvim-treesitter-context
-- 画面上部に現在の関数/クラス/ブロック等のコンテキストを固定表示し、
-- 長い関数の中でも「今どこにいるか」が分かるようにする

return {
  'nvim-treesitter/nvim-treesitter-context',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    max_lines = 3, -- コンテキスト表示の最大行数
    multiline_threshold = 1, -- 複数行の場合は1行に集約
    trim_scope = 'outer',
  },
  keys = {
    {
      '<leader>uc',
      function()
        require('treesitter-context').toggle()
      end,
      desc = '[U]I: Toggle treesitter [C]ontext',
    },
  },
}
