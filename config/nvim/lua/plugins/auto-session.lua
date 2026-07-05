-- auto-session
-- プロジェクト（cwd）ごとにセッションを自動保存/復元
-- nvim で開くと前回のバッファ/タブ/ウィンドウ構成が復元される

return {
  'rmagatti/auto-session',
  lazy = false,
  opts = {
    suppressed_dirs = { '~/', '~/Downloads', '~/Documents', '/' },
    auto_restore = true,
    auto_save = true,
    use_git_branch = true,
    bypass_save_filetypes = { 'oil', 'neo-tree', 'dashboard' },
  },
  keys = {
    { '<leader>ps', '<cmd>SessionSearch<cr>', desc = '[P]roject [S]ession 検索' },
    { '<leader>pd', '<cmd>SessionDelete<cr>', desc = '[P]roject Session [D]elete' },
  },
}
