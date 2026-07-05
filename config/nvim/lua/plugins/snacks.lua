return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    -- snacks.nvimの基本設定
    -- claudecode.nvimで使用するterminal機能を有効化
    terminal = {
      enabled = true,
    },
    -- ダッシュボード: 最近開いたファイルやプロジェクトを表示
    dashboard = {
      enabled = true,
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        {
          icon = ' ',
          title = 'Projects',
          section = 'projects',
          limit = 8,
          indent = 2,
          padding = 1,
          action = function(dir)
            vim.cmd('silent! SessionSave')
            vim.cmd('silent! %bdelete!')
            vim.fn.chdir(dir)
            vim.cmd('silent! SessionRestore')
          end,
        },
        {
          icon = ' ',
          title = 'Recent Files',
          section = 'recent_files',
          cwd = false,
          limit = 5,
          indent = 2,
          padding = 1,
        },
        { section = 'startup' },
      },
      preset = {
        keys = {
          { icon = ' ', key = 'f', desc = 'Find File', action = ":lua require('telescope.builtin').find_files()" },
          { icon = ' ', key = 'n', desc = 'New File', action = ':enew' },
          { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua require('telescope.builtin').live_grep()" },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua require('telescope.builtin').oldfiles()" },
          { icon = '󰁯', key = 's', desc = 'Restore Session', action = ':SessionRestore' },
          { icon = '󰒲', key = 'l', desc = 'Lazy', action = ':Lazy' },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
    },
  },
  keys = {
    {
      '<leader>.',
      function()
        Snacks.dashboard()
      end,
      desc = 'Dashboard',
    },
  },
  config = function(_, opts)
    require('snacks').setup(opts)
  end,
}