-- C/C++ デバッガー設定（codelldb）
-- .vscode/launch.json と .nvim.lua の両方に対応
--
-- 【プロジェクト固有設定の方法】
--
-- 1. .vscode/launch.json (VSCode と共有)
--    {
--      "version": "0.2.0",
--      "configurations": [
--        {
--          "name": "Debug",
--          "type": "codelldb",
--          "request": "launch",
--          "program": "${workspaceFolder}/build/my_app",
--          "args": [],
--          "cwd": "${workspaceFolder}"
--        }
--      ]
--    }
--
-- 2. .nvim.lua (Neovim 専用)
--    local dap = require('dap')
--    dap.configurations.cpp = {
--      {
--        name = 'Debug',
--        type = 'codelldb',
--        request = 'launch',
--        program = '${workspaceFolder}/build/my_app',
--        args = {},
--        cwd = '${workspaceFolder}',
--      },
--    }
--    dap.configurations.c = dap.configurations.cpp

return function()
  local dap = require('dap')

  -- codelldb アダプター設定
  dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
      command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
      args = { '--port', '${port}' },
    },
  }

  -- C++ デフォルトデバッグ設定（プロジェクト固有設定がない場合のフォールバック）
  dap.configurations.cpp = {
    {
      name = 'Launch file',
      type = 'codelldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
    },
    {
      name = 'Attach to process',
      type = 'codelldb',
      request = 'attach',
      pid = require('dap.utils').pick_process,
      args = {},
    },
  }

  -- C も同じ設定を使用
  dap.configurations.c = dap.configurations.cpp

  -- .vscode/launch.json の自動読み込み（プロジェクトルートに存在する場合）
  -- これにより、VSCode と同じデバッグ設定を共有可能
  require('dap.ext.vscode').load_launchjs(nil, { codelldb = { 'c', 'cpp' } })
end
