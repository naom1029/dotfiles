-- nvim-web-devicons
-- ファイルタイプアイコン表示

return {
  'nvim-tree/nvim-web-devicons',
  lazy = false, -- 他のプラグインの依存関係として必要なため、すぐにロード
  priority = 1000, -- 他のプラグインより先に読み込む
  opts = {
    -- 既定のアイコンを使用
    default = true,
  },
}
