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
            vim.cmd('silent! %bdelete!')
            vim.fn.chdir(dir)
            vim.cmd('Neotree filesystem focus')
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