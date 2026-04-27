-- TypeScript Language Server 設定

return {
  root_dir = function(fname)
    -- 優先順位: tsconfig.json > package.json > .git
    return vim.fs.root(fname, { 'tsconfig.json' })
      or vim.fs.root(fname, { 'package.json' })
      or vim.fs.root(fname, { '.git' })
  end,
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
}
