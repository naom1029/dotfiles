-- inc-rename.nvim
-- LSP rename を「変更箇所をライブプレビューしながら」実行する。
-- キーマップ <leader>rn は lua/plugins/lsp/init.lua の LspAttach 内で
-- :IncRename に差し替えている（<cword> をプリフィル）。

return {
  'smjonas/inc-rename.nvim',
  cmd = 'IncRename',
  opts = {},
}
