-- DAP (Debug Adapter Protocol) 基本設定

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-neotest/nvim-nio',
  },
  keys = {
    -- デバッグ実行
    { '<F5>', function() require('dap').continue() end, desc = 'DAP: Start/Continue' },
    { '<leader>dc', function() require('dap').continue() end, desc = 'DAP: [C]ontinue' },
    { '<leader>dt', function() require('dap').terminate() end, desc = 'DAP: [T]erminate' },

    -- ブレイクポイント
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'DAP: Toggle [B]reakpoint' },
    { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'DAP: Set Conditional [B]reakpoint' },

    -- ステップ実行
    { '<F10>', function() require('dap').step_over() end, desc = 'DAP: Step Over' },
    { '<F11>', function() require('dap').step_into() end, desc = 'DAP: Step Into' },
    { '<F12>', function() require('dap').step_out() end, desc = 'DAP: Step Out' },
    { '<leader>dso', function() require('dap').step_over() end, desc = 'DAP: [S]tep [O]ver' },
    { '<leader>dsi', function() require('dap').step_into() end, desc = 'DAP: [S]tep [I]nto' },
    { '<leader>dsO', function() require('dap').step_out() end, desc = 'DAP: [S]tep [O]ut' },

    -- UI
    { '<leader>du', function() require('dapui').toggle() end, desc = 'DAP: Toggle [U]I' },
    { '<leader>de', function() require('dapui').eval() end, desc = 'DAP: [E]val', mode = { 'n', 'v' } },
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    -- UI setup
    dapui.setup()
    require('nvim-dap-virtual-text').setup()

    -- デバッガー起動時に UI を自動的に開く
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    -- 言語固有のデバッグ設定を読み込み
    require('plugins.dap.cpp')()
    require('plugins.dap.rust')()
    require('plugins.dap.vscode-js')()
  end,
}
