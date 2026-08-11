-- Lua Language Server 設定

return {
  cmd = { vim.fn.stdpath('data') .. '/mason/bin/lua-language-server' },
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
