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
    -- lazygit: フロートの枠線（テーマ連動のTUI統合はデフォルトのまま）
    lazygit = {
      win = {
        border = 'rounded',
      },
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
    -- indent: インデントガイド（レインボー + スコープ強調）
    indent = {
      enabled = true,
      indent = {
        char = '│',
        hl = {
          'RainbowRed',
          'RainbowYellow',
          'RainbowBlue',
          'RainbowOrange',
          'RainbowGreen',
          'RainbowViolet',
          'RainbowCyan',
        },
      },
      scope = {
        enabled = true,
        underline = true,
        char = '│',
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
    -- LazyGit
    {
      '<leader>gl',
      function()
        Snacks.lazygit()
      end,
      desc = 'LazyGit を開く',
    },
    {
      '<leader>gf',
      function()
        Snacks.lazygit({ cwd = vim.fn.expand('%:p:h') })
      end,
      desc = '現在のファイルのリポジトリでLazyGit',
    },
    {
      '<leader>gF',
      function()
        Snacks.lazygit.log_file()
      end,
      desc = '現在のファイルのログ（フィルタ表示）',
    },
    {
      '<leader>gc',
      function()
        vim.cmd.edit(vim.fn.fnameescape(vim.fn.expand('~/src/github.com/naom1029/dotfiles/nix/programs/lazygit.nix')))
      end,
      desc = 'LazyGit 設定を開く（nix）',
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
    -- インデントガイドのレインボー色（カラースキーム切替時に消えるため都度再適用）
    local function set_rainbow_hl()
      local colors = {
        RainbowRed = '#E06C75',
        RainbowYellow = '#E5C07B',
        RainbowBlue = '#61AFEF',
        RainbowOrange = '#D19A66',
        RainbowGreen = '#98C379',
        RainbowViolet = '#C678DD',
        RainbowCyan = '#56B6C2',
      }
      for name, fg in pairs(colors) do
        vim.api.nvim_set_hl(0, name, { fg = fg })
      end
      -- scopeガイドの色はテーマのibl用定義（IblScope）があればそれに合わせる
      -- （snacksのデフォルトはSpecialリンクで、テーマによって色味が変わるため）
      local ibl_scope = vim.api.nvim_get_hl(0, { name = 'IblScope', link = false })
      if ibl_scope.fg then
        vim.api.nvim_set_hl(0, 'SnacksIndentScope', { fg = ibl_scope.fg })
      end
    end
    set_rainbow_hl()
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('snacks-indent-rainbow', { clear = true }),
      callback = set_rainbow_hl,
    })

    -- LazyGit終了時にGit状態の表示を追従させる
    -- （gitsigns/neo-treeのwatcherだけではgitバッジ更新が遅れる場合があるため）
    vim.api.nvim_create_autocmd('TermClose', {
      pattern = '*lazygit',
      group = vim.api.nvim_create_augroup('lazygit-refresh', { clear = true }),
      callback = function()
        vim.defer_fn(function()
          vim.cmd('checktime')
          pcall(vim.cmd, 'Gitsigns refresh')
          pcall(vim.cmd, 'Neotree refresh')
          local branch = vim.fn.system('git branch --show-current 2>/dev/null'):gsub('\n', '')
          if branch ~= '' then
            vim.notify('Current branch: ' .. branch, vim.log.levels.INFO)
          end
        end, 100)
      end,
    })

    -- コミットメッセージ等にはインデントガイドを出さない
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'gitcommit',
      group = vim.api.nvim_create_augroup('snacks-indent-exclude', { clear = true }),
      callback = function(ev)
        vim.b[ev.buf].snacks_indent = false
      end,
    })

    require('snacks').setup(opts)
  end,
}