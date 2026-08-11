-- C/C++ Language Server (clangd) 設定
-- after/lsp/ はNeovimネイティブのLSP設定ディレクトリ（:h lsp-config）。
-- runtimepathの最後にマージされるため、ここで指定したキーだけが
-- nvim-lspconfig のデフォルト定義を上書きする。指定しないキー
-- （filetypes, on_attach 等）はデフォルト定義が使われる。

return {
  cmd = {
    vim.fn.stdpath('data') .. '/mason/bin/clangd',
    '--background-index',
    '--header-insertion=never',
    '--clang-tidy',
  },
  -- 優先順位: C/C++プロジェクトマーカー > .git > Makefile
  -- （ネストしたリストは同順位グループ。:h lsp-root_markers）
  root_markers = {
    { '.clangd', 'compile_commands.json', 'compile_flags.txt' },
    '.git',
    'Makefile',
  },
}
