-- TypeScript Language Server 設定
-- after/lsp/ はNeovimネイティブのLSP設定ディレクトリ（:h lsp-config）。
-- ここで指定したキーだけが nvim-lspconfig のデフォルト定義を上書きする。

return {
  -- 優先順位: tsconfig.json > package.json > .git（リスト順 = 優先順位）
  root_markers = {
    'tsconfig.json',
    'package.json',
    '.git',
  },
}
