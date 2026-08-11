-- シェル用ターミナルの共通win設定
-- ターミナルモードから<C-h/j/k/l>で直接ウィンドウ移動できるようにする
-- （lazygit等のTUIウィンドウにキーを注入しないよう、シェル用のキーマップ側でのみ使う）
local function term_win(win)
  win.keys = {
    term_win_h = { '<C-h>', '<cmd>wincmd h<cr>', mode = 't', desc = '左のウィンドウへ' },
    term_win_j = { '<C-j>', '<cmd>wincmd j<cr>', mode = 't', desc = '下のウィンドウへ' },
    term_win_k = { '<C-k>', '<cmd>wincmd k<cr>', mode = 't', desc = '上のウィンドウへ' },
    term_win_l = { '<C-l>', '<cmd>wincmd l<cr>', mode = 't', desc = '右のウィンドウへ' },
  }
  return win
end

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
    -- input: vim.ui.input の見た目改善
    input = {
      enabled = true,
    },
    -- picker: vim.ui.select を snacks picker に置き換え（ui_select はデフォルト有効）
    picker = {
      enabled = true,
      win = {
        input = {
          keys = {
            -- 挿入モードからもEsc1回で閉じる
            ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
          },
        },
      },
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
            vim.cmd('silent! AutoSession save')
            vim.cmd('silent! %bdelete!')
            vim.fn.chdir(dir)
            vim.cmd('silent! AutoSession restore')
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
          { icon = '󰁯', key = 's', desc = 'Restore Session', action = ':AutoSession restore' },
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
    -- ターミナル
    -- 方向ごとにcountでターミナルIDを分離する（同一IDだと最初に開いた
    -- 位置・サイズが固定され、tf/th/tvの切替が効かなくなるため）
    -- 下部=1（<C-\>と共有）、フロート=2、右=3
    {
      '<C-\\>',
      function()
        Snacks.terminal.toggle(nil, { count = 1, win = term_win({ position = 'bottom', height = 0.3 }) })
      end,
      desc = 'ターミナルをトグル（下部）',
      mode = { 'n', 't', 'i' },
    },
    {
      '<leader>th',
      function()
        Snacks.terminal.toggle(nil, { count = 1, win = term_win({ position = 'bottom', height = 0.3 }) })
      end,
      desc = '水平分割ターミナル',
    },
    {
      '<leader>tf',
      function()
        Snacks.terminal.toggle(nil, { count = 2, win = term_win({ position = 'float', border = 'rounded' }) })
      end,
      desc = 'フローティングターミナル',
    },
    {
      '<leader>tv',
      function()
        Snacks.terminal.toggle(nil, { count = 3, win = term_win({ position = 'right', width = 0.4 }) })
      end,
      desc = '垂直分割ターミナル',
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