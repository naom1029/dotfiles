-- JavaScript/TypeScript デバッガー設定

return {
  'mfussenegger/nvim-dap-vscode-js',
  dependencies = { 'mfussenegger/nvim-dap' },
  config = function()
    local dap = require('dap')

    -- vscode-js-debug のセットアップ
    require('dap-vscode-js').setup({
      debugger_path = vim.fn.expand('~/.config/nvim/js-debug'),
      adapters = { 'pwa-node', 'pwa-chrome', 'pwa-deno' },
    })

    -- TypeScript のデバッグ設定
    dap.configurations.typescript = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch TS',
        program = '${file}',
        cwd = '${workspaceFolder}',
      },
    }

    -- JavaScript も同じ設定を使用
    dap.configurations.javascript = dap.configurations.typescript
  end,
}
