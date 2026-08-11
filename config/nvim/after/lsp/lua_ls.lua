-- Lua Language Server 設定
-- after/lsp/ はNeovimネイティブのLSP設定ディレクトリ（:h lsp-config）。
-- ここで指定したキーだけが nvim-lspconfig のデフォルト定義を上書きする。
-- 注意: workspace.library と diagnostics.globals は lazydev.nvim が
-- 動的に管理するため、ここには書かないこと（静的に書くとlazydevが無効化される）

return {
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
