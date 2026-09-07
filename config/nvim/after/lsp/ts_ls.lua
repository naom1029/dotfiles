-- TypeScript Language Server 設定
-- after/lsp/ はNeovimネイティブのLSP設定ディレクトリ（:h lsp-config）。
-- ここで指定したキーだけが nvim-lspconfig のデフォルト定義を上書きする。

local vue_language_server_path = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'

return {
  -- Vue Language Server v3 はハイブリッドモードで動作する。
  -- .vue 内のTypeScriptは ts_ls と @vue/typescript-plugin が担当する。
  init_options = {
    plugins = {
      {
        name = '@vue/typescript-plugin',
        location = vue_language_server_path,
        languages = { 'vue' },
        configNamespace = 'typescript',
      },
    },
  },
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
  },
  -- 優先順位: tsconfig.json > package.json > .git（リスト順 = 優先順位）
  root_markers = {
    'tsconfig.json',
    'package.json',
    '.git',
  },
}
