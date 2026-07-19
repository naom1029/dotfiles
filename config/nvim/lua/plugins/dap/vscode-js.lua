-- JavaScript/TypeScript デバッガー設定（vscode-js-debug 直接登録方式）
--
-- 接着剤プラグイン（nvim-dap-vscode-js）は使わず、Mason で導入した
-- vscode-js-debug（js-debug-adapter）を nvim-dap に直接登録する。
-- プラグイン依存が減り、メンテ停滞の影響を受けにくい。
--
-- 前提: `:MasonInstall js-debug-adapter`
--   → ~/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js
--
-- 【プロジェクト固有設定の方法】
--
-- 1. .vscode/launch.json (VSCode と共有・自動読み込み)
--    {
--      "version": "0.2.0",
--      "configurations": [
--        {
--          "type": "pwa-node",
--          "request": "launch",
--          "name": "Debug with tsx",
--          "runtimeExecutable": "node",
--          "runtimeArgs": ["--import", "tsx"],
--          "program": "${workspaceFolder}/src/index.ts",
--          "cwd": "${workspaceFolder}"
--        }
--      ]
--    }
--
-- 2. .nvim.lua (Neovim 専用)
--    local dap = require('dap')
--    dap.configurations.typescript = { { ... } }

return function()
  local dap = require('dap')

  -- vscode-js-debug 本体（DAP サーバー）のエントリポイント
  local debug_server = vim.fn.stdpath('data')
    .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js'

  -- アダプター登録（server 型: 起動したサーバーにクライアントが接続する）
  local adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }
  for _, adapter in ipairs(adapters) do
    dap.adapters[adapter] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'node',
        args = { debug_server, '${port}' },
      },
    }
  end

  -- デフォルトデバッグ設定（プロジェクト固有設定がない場合のフォールバック）
  local configurations = {
    {
      -- Node ネイティブの型ストリップで実行（依存不要・単純な .ts / .js 向け）
      -- 注意: `import { Foo }` のような値混在 import があるファイルは失敗する。
      --       その場合は下の "Launch file (tsx)" を使う。
      type = 'pwa-node',
      request = 'launch',
      name = 'Launch file (Node, native TS)',
      program = '${file}',
      cwd = '${workspaceFolder}',
      sourceMaps = true,
      protocol = 'inspector',
      skipFiles = { '<node_internals>/**' },
    },
    {
      -- tsx 経由で実行（TS を完全トランスパイル・CJS/ESM interop 解決）
      -- 前提: プロジェクトに tsx（`pnpm add -D tsx` など）or `npm i -g tsx`
      type = 'pwa-node',
      request = 'launch',
      name = 'Launch file (tsx)',
      runtimeExecutable = 'node',
      runtimeArgs = { '--import', 'tsx' },
      program = '${file}',
      cwd = '${workspaceFolder}',
      sourceMaps = true,
      protocol = 'inspector',
      skipFiles = { '<node_internals>/**' },
    },
    {
      type = 'pwa-node',
      request = 'attach',
      name = 'Attach to process',
      processId = require('dap.utils').pick_process,
      cwd = '${workspaceFolder}',
      sourceMaps = true,
      skipFiles = { '<node_internals>/**' },
    },
  }

  for _, lang in ipairs({ 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' }) do
    dap.configurations[lang] = configurations
  end

  -- .vscode/launch.json の自動読み込み（プロジェクトルートに存在する場合）
  -- VSCode と同じデバッグ設定を共有可能
  pcall(function()
    require('dap.ext.vscode').load_launchjs(nil, {
      ['pwa-node'] = { 'javascript', 'typescript' },
      ['node'] = { 'javascript', 'typescript' },
    })
  end)
end
