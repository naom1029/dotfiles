return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  init = function()
    -- debug: どこでも綺麗に値を print（dd）/ バックトレース（bt）。vim.print も置換
    _G.dd = function(...)
      Snacks.debug.inspect(...)
    end
    _G.bt = function()
      Snacks.debug.backtrace()
    end
    vim.print = _G.dd
  end,
  opts = {
    -- snacks.nvimの基本設定
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
    -- words: LSP(document_highlight)ベースで同一シンボル間をジャンプ（]] / [[）
    words = {
      enabled = true,
    },
    -- bigfile: 巨大ファイルを開いたら LSP/treesitter 等を自動で無効化して軽量化
    bigfile = {
      enabled = true,
    },
    -- quickfile: プラグイン読込前にファイルを即描画して起動を高速化
    quickfile = {
      enabled = true,
    },
    -- scroll: スムーズスクロール（合わなければ enabled = false に）
    scroll = {
      enabled = true,
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
    {
      ']r',
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = '次の同一シンボル参照へ',
      mode = { 'n', 't' },
    },
    {
      '[r',
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = '前の同一シンボル参照へ',
      mode = { 'n', 't' },
    },
    {
      '<leader>gB',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'ブラウザで開く (GitHub permalink)',
      mode = { 'n', 'v' },
    },
    {
      '<leader>bd',
      function()
        Snacks.bufdelete()
      end,
      desc = 'バッファ削除 (レイアウト保持)',
    },
  },
  config = function(_, opts)
    require('snacks').setup(opts)
  end,
}