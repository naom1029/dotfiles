-- Rust デバッガー設定（codelldb）

return function()
  local dap = require('dap')

  -- Rust デバッグ設定
  dap.configurations.rust = {
    {
      name = 'Launch',
      type = 'codelldb',
      request = 'launch',
      program = function()
        -- Cargo プロジェクトから実行ファイルを推測
        local cwd = vim.fn.getcwd()
        return vim.fn.input('Path to executable: ', cwd .. '/target/debug/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
      runInTerminal = false,
    },
    {
      name = 'Attach to process',
      type = 'codelldb',
      request = 'attach',
      pid = require('dap.utils').pick_process,
      args = {},
    },
  }
end
