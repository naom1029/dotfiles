-- tailwindcss-language-server 設定

local util = require 'lspconfig.util'

return {
  -- lspconfig のデフォルトは root_files に '.git' を含む（tailwind v4 で
  -- tailwind.config.* が必須でなくなったことへのフォールバック）。
  -- その結果、Tailwind と無関係なリポジトリでも ts/tsx/js/css/scss/md/html/vue を
  -- 開くたびに node プロセスが1本起動していた。
  -- v4 でも npm 依存には tailwindcss が入るので、package.json の依存を見れば足りる。
  root_dir = function(bufnr, on_dir)
    local root_files = {
      'tailwind.config.js',
      'tailwind.config.cjs',
      'tailwind.config.mjs',
      'tailwind.config.ts',
      'postcss.config.js',
      'postcss.config.cjs',
      'postcss.config.mjs',
      'postcss.config.ts',
    }
    local fname = vim.api.nvim_buf_get_name(bufnr)
    root_files = util.insert_package_json(root_files, 'tailwindcss', fname)

    local found = vim.fs.find(root_files, { path = fname, upward = true })[1]
    -- 見つからない場合は on_dir を呼ばない = サーバーを起動しない
    if found then
      on_dir(vim.fs.dirname(found))
    end
  end,
}
