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
      -- test/ 内の oj サンプル（sample-*.in）を選んで標準入力に流す（AtCoder 用）
      name = 'Launch file (test/ のサンプル入力)',
      type = 'codelldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.expand('%:p:h') .. '/', 'file')
      end,
      cwd = '${fileDirname}',
      stopOnEntry = false,
      -- test/*.in を列挙し、複数あれば選択して stdin に流す
      stdio = function()
        local dir = vim.fn.expand('%:p:h') .. '/test'
        local ins = vim.fn.glob(dir .. '/*.in', false, true)
        if #ins == 0 then
          vim.notify('test/*.in が見つかりません（手入力にフォールバック）', vim.log.levels.WARN)
          return nil
        end
        if #ins == 1 then
          return { ins[1], vim.NIL, vim.NIL }
        end
        local items = { '標準入力に使うサンプルを選択:' }
        for i, f in ipairs(ins) do
          items[i + 1] = i .. ': ' .. vim.fn.fnamemodify(f, ':t')
        end
        local choice = vim.fn.inputlist(items)
        return { ins[choice] or ins[1], vim.NIL, vim.NIL }
      end,
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
