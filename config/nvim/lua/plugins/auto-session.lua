-- auto-session
-- プロジェクト（cwd）ごとにセッションを自動保存/復元
-- nvim で開くと前回のバッファ/タブ/ウィンドウ構成が復元される

return {
  'rmagatti/auto-session',
  lazy = false,
  opts = {
    suppressed_dirs = { '~/', '~/Downloads', '~/Documents', '/' },
    auto_restore = false,
    auto_save = true,
    git_use_branch_name = true,
    bypass_save_filetypes = { 'oil', 'neo-tree', 'dashboard', 'snacks_dashboard' },
    -- 実ファイルを持たない補助ウィンドウは保存前に閉じる。
    -- 残すとセッション復元時にこれらだけが復元され、肝心のファイルが
    -- どのウィンドウにも表示されない状態になる
    close_filetypes_on_save = {
      'checkhealth',
      'neotest-summary',
      'neotest-output',
      'neotest-output-panel',
      'trouble',
      'aerial',
      'snacks_terminal',
      'dapui_scopes',
      'dapui_breakpoints',
      'dapui_stacks',
      'dapui_watches',
      'dapui_console',
      'dap-repl',
    },
  },
  keys = {
    { '<leader>ps', '<cmd>AutoSession search<cr>', desc = '[P]roject [S]ession 検索' },
    { '<leader>pr', '<cmd>AutoSession restore<cr>', desc = '[P]roject Session [R]estore' },
    { '<leader>pd', '<cmd>AutoSession delete<cr>', desc = '[P]roject Session [D]elete' },
  },
}
