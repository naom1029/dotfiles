-- toggleterm.nvim
-- ターミナルを簡単にトグルできるプラグイン

return {
  'akinsho/toggleterm.nvim',
  version = '*',
  keys = {
    { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Toggle floating terminal' },
    { '<leader>th', '<cmd>ToggleTerm direction=horizontal<cr>', desc = 'Toggle horizontal terminal' },
    { '<leader>tv', '<cmd>ToggleTerm direction=vertical<cr>', desc = 'Toggle vertical terminal' },
  },
  config = function()
    require('toggleterm').setup({
      autochdir = true, -- rooter等でcwdが変わったとき、次回オープン時に追従
      size = function(term)
        if term.direction == 'horizontal' then
          return vim.o.lines * 0.3 -- ウィンドウの30%（VSCode風）
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<C-\>]], -- Ctrl+\ でトグル
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = 'horizontal', -- デフォルトは下部に表示
      close_on_exit = true,
      shell = vim.o.shell,
      auto_scroll = true,
      float_opts = {
        border = 'curved',
        winblend = 0,
        highlights = {
          border = 'Normal',
          background = 'Normal',
        },
      },
    })

    -- ターミナルモードでのキーマップ
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    end

    vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
  end,
}
