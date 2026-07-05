return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  config = true,
  keys = {
    { '<leader>at', '<cmd>ClaudeCode<cr>', desc = '[A]I [T]oggle Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = '[A]I [F]ocus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = '[A]I [R]esume Claude' },
    { '<leader>ac', '<cmd>ClaudeCode --continue<cr>', desc = '[A]I [C]ontinue Claude' },
    { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = '[A]I Select [M]odel' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = '[A]I Add current [B]uffer' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = '[A]I [S]end to Claude' },
    {
      '<leader>as',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = '[A]I Add file from tree',
      ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
    },
    -- Diff management
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = '[A]I [A]ccept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = '[A]I [D]eny diff' },
  },
}