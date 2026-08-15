-- nvim-web-devicons
-- ファイルタイプアイコン表示

return {
  'nvim-tree/nvim-web-devicons',
  -- 他プラグインのdependenciesとして必要になったタイミングで自動ロードされるため
  -- ここでの明示的なeager loadは不要
  opts = {
    -- 既定のアイコンを使用
    default = true,
  },
}
