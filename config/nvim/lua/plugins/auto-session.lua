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
    use_git_branch = true,
    bypass_save_filetypes = { 'oil', 'neo-tree', 'dashboard' },
  },
  keys = {
    { '<leader>ps', '<cmd>SessionSearch<cr>', desc = '[P]roject [S]ession 検索' },
    { '<leader>pr', '<cmd>SessionRestore<cr>', desc = '[P]roject Session [R]estore' },
    { '<leader>pd', '<cmd>SessionDelete<cr>', desc = '[P]roject Session [D]elete' },
  },
}
