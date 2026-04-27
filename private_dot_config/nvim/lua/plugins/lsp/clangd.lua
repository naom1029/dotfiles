-- C/C++ Language Server (clangd) 設定

return {
  cmd = {
    vim.fn.stdpath('data') .. '/mason/bin/clangd',
    '--background-index',
    '--header-insertion=never',
    '--clang-tidy',
  },
  root_dir = function(fname)
    -- 優先順位: C/C++プロジェクトマーカー > .git > Makefile
    return vim.fs.root(fname, { '.clangd', 'compile_commands.json', 'compile_flags.txt' })
      or vim.fs.root(fname, { '.git' })
      or vim.fs.root(fname, { 'Makefile' })
  end,
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
}
