-- nvim-rooter.lua
-- ファイルを開いたときに自動でプロジェクトルート（git root）に cd する

return {
  'notjedi/nvim-rooter.lua',
  lazy = false, -- 常時有効化（自動cd機能のため）
  config = function()
    require('nvim-rooter').setup({
      rooter_patterns = {
        '.git',
        -- Git管理外のフォールバック
        'Cargo.toml',
        'go.mod',
        'Makefile',
      },
      trigger_patterns = { '*' },
      manual = false,
      cd_scope = 'global',
      fallback_to_parent = false,
    })
  end,
}
