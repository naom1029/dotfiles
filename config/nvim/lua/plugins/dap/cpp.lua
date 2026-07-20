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
      -- 標準入力(cin)を統合ターミナルで手入力できるようにする
      console = 'integratedTerminal',
    },
    {
      -- 現在ファイルと同じディレクトリの input.txt を標準入力に流す（AtCoder のサンプル用）
      name = 'Launch file (input.txt を標準入力に)',
      type = 'codelldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.expand('%:p:h') .. '/', 'file')
      end,
      cwd = '${fileDirname}',
      stopOnEntry = false,
      -- stdio = { stdin, stdout, stderr }。stdin を input.txt に、出力は既定のまま
      stdio = { 'input.txt', vim.NIL, vim.NIL },
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
end
