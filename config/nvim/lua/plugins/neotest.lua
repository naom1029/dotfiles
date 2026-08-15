-- neotest
-- VSCodeのTestingパネル相当。個々のテストの実行・ツリー表示・デバッグを行う
-- 対応言語: Python, Lua(plenary/busted), C++(CTest), TypeScript/JavaScript(Jest/Vitest)
-- Rustは見送り（rustaceanvimはLSP管理を丸ごと引き取る仕様のため別途検討）

return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-python',
    'nvim-neotest/neotest-plenary',
    'orjangj/neotest-ctest',
    'nvim-neotest/neotest-jest',
    'marilari88/neotest-vitest',
  },
  keys = {
    {
      '<leader>nt',
      function()
        require('neotest').run.run()
      end,
      desc = 'Test: 最も近いテストを実行',
    },
    {
      '<leader>nT',
      function()
        require('neotest').run.run(vim.fn.expand('%'))
      end,
      desc = 'Test: 現在ファイルのテストを実行',
    },
    {
      '<leader>nA',
      function()
        require('neotest').run.run({ suite = true })
      end,
      desc = 'Test: プロジェクト全体のテストを実行',
    },
    {
      '<leader>nd',
      function()
        require('neotest').run.run({ strategy = 'dap' })
      end,
      desc = 'Test: 最も近いテストをデバッグ実行',
    },
    {
      '<leader>ns',
      function()
        require('neotest').summary.toggle()
      end,
      desc = 'Test: サマリー(ツリー)をトグル',
    },
    {
      '<leader>no',
      function()
        require('neotest').output.open({ enter = true, auto_close = true })
      end,
      desc = 'Test: 直近の実行結果を表示',
    },
    {
      '<leader>nO',
      function()
        require('neotest').output_panel.toggle()
      end,
      desc = 'Test: 出力パネルをトグル',
    },
  },
  opts = function()
    return {
      -- サマリー(ツリー)を左側に表示（デフォルトは右側）
      summary = {
        open = 'topleft vsplit | vertical resize 50',
        mappings = {
          -- Enterは後述のハイブリッド処理で上書きする（展開できる行は展開、
          -- 末端のテスト行はジャンプ）。常にジャンプしたいとき用に<C-i>も残す
          jumpto = { '<C-i>', 'i' },
        },
      },
      output = {
        -- 実行のたびに出力フロートが勝手に出るのを止める（結果は下部パネルで見る）。
        -- フロートで見たいときは<leader>no（ツリー内ならo）
        open_on_run = false,
      },
      -- 実行結果を確認できるよう、テストが終わったら下部の出力パネルを自動で開く。
      -- neotestに自動オープンの設定は無いため、consumersの拡張点で
      -- 結果イベント（results）を購読して開く。
      consumers = {
        auto_open_output_panel = function(client)
          client.listeners.results = function(_, _, partial)
            -- partialは実行途中の部分結果なので、完了時だけ見る
            if partial then
              return
            end
            vim.schedule(function()
              require('neotest').output_panel.open()
            end)
          end
        end,
      },
      adapters = {
        require('neotest-python')({
          dap = { justMyCode = false },
        }),
        require('neotest-plenary'),
        require('neotest-ctest').setup({}),
        require('neotest-jest')({}),
        require('neotest-vitest'),
      },
    }
  end,
  config = function(_, opts)
    -- gtestはパイプ出力だと色を落とすため、失敗時の出力が読みづらくなる。
    -- Neovimから起動する子プロセスにだけ効かせ、シェルやCIには影響させない。
    -- （neotest-ctestはRunSpecにenvを渡す口が無いのでvim.env経由にする）
    vim.env.GTEST_COLOR = 'yes'

    -- neotest本体とneotest-jestが非推奨のvim.tbl_flatten()を呼んでおり、
    -- その非推奨警告(vim.deprecate→nvim_echo)が非同期の安全でないコンテキスト
    -- から呼ばれてクラッシュする(E5560)。
    -- 挙動を変えずに警告だけ出さない同等実装で上書きして回避する。
    vim.tbl_flatten = function(t)
      local result = {}
      local function go(tt)
        for i = 1, #tt do
          local v = tt[i]
          if type(v) == 'table' then
            go(v)
          elseif v then
            result[#result + 1] = v
          end
        end
      end
      go(t)
      return result
    end

    require('neotest').setup(opts)

    -- ツリーのEnterをハイブリッドにする:
    --   展開できる行（ディレクトリ/ファイル/スイート）→ 標準どおり展開・折りたたみ
    --   末端のテスト行 → そのテストへジャンプ（バッファに開く）
    -- neotestは「その行にどのアクションが登録されているか」を公開していないため、
    -- Canvasのadd_mappingを包んで展開可能な行を記録し、描画のたびに
    -- render_bufferの後で自前のEnterを張り直す。
    local canvas_module = require('neotest.consumers.summary.canvas')
    local expandable_lines = {}
    local orig_canvas_new = canvas_module.new
    canvas_module.new = function(canvas_config)
      local canvas = orig_canvas_new(canvas_config)
      -- 描画ごとにCanvasが作り直されるので、そのタイミングで記録もリセットする
      expandable_lines = {}

      local orig_add_mapping = canvas.add_mapping
      canvas.add_mapping = function(self, action, callback, map_opts)
        if action == 'expand' then
          expandable_lines[(map_opts and map_opts.line) or self:length()] = true
        end
        return orig_add_mapping(self, action, callback, map_opts)
      end

      local orig_render_buffer = canvas.render_buffer
      canvas.render_buffer = function(self, buffer)
        local rendered = orig_render_buffer(self, buffer)
        vim.keymap.set('n', '<CR>', function()
          local action = expandable_lines[vim.fn.line('.')] and 'expand' or 'jumpto'
          for _, map in ipairs(vim.api.nvim_buf_get_keymap(buffer, 'n')) do
            if map.callback and map.desc and vim.startswith(map.desc, action) then
              map.callback()
              return
            end
          end
        end, { buffer = buffer, nowait = true, desc = 'neotest: 展開 or ジャンプ' })
        return rendered
      end

      return canvas
    end

    -- ツリーでカーソルを合わせたテストのコードをフロートでプレビューする
    -- （Enterで実際に開く前に中身を確認できるようにする）。
    -- neotestは「カーソル行→テスト位置」の対応を公開APIで提供していないため、
    -- jumptoのコールバックを流用する。ジャンプ処理の実体である
    -- lib.ui.open_buf を一時的に差し替えて、ウィンドウを切り替えず
    -- 対象バッファと行だけを受け取る。
    local preview_win = nil

    local function close_preview()
      if preview_win and vim.api.nvim_win_is_valid(preview_win) then
        vim.api.nvim_win_close(preview_win, true)
      end
      preview_win = nil
    end

    local function capture_position_under_cursor()
      local ok_lib, lib = pcall(require, 'neotest.lib')
      if not ok_lib then
        return nil
      end
      local captured
      local orig_open_buf = lib.ui.open_buf
      lib.ui.open_buf = function(bufnr, line, col)
        captured = { buf = bufnr, line = line or 0, col = col or 0 }
      end
      for _, map in ipairs(vim.api.nvim_buf_get_keymap(0, 'n')) do
        if map.callback and map.desc and map.desc:match('^jumpto') then
          pcall(map.callback)
          break
        end
      end
      lib.ui.open_buf = orig_open_buf
      return captured
    end

    local function show_preview()
      if vim.bo.filetype ~= 'neotest-summary' then
        return
      end
      local pos = capture_position_under_cursor()
      -- ディレクトリ行などジャンプ先が無い行ではプレビューを閉じる
      if not pos or not vim.api.nvim_buf_is_valid(pos.buf) then
        close_preview()
        return
      end

      local width = math.min(math.floor(vim.o.columns * 0.5), 100)
      local height = math.min(math.floor(vim.o.lines * 0.5), 30)
      local win_config = {
        relative = 'editor',
        width = width,
        height = height,
        row = 1,
        col = vim.o.columns - width - 2,
        border = 'rounded',
        title = ' ' .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(pos.buf), ':t') .. ' ',
        title_pos = 'center',
        focusable = false,
        noautocmd = true,
      }

      if preview_win and vim.api.nvim_win_is_valid(preview_win) then
        vim.api.nvim_win_set_config(preview_win, win_config)
        vim.api.nvim_win_set_buf(preview_win, pos.buf)
      else
        preview_win = vim.api.nvim_open_win(pos.buf, false, win_config)
      end

      vim.wo[preview_win].number = true
      vim.wo[preview_win].cursorline = true
      local line = math.min(pos.line + 1, vim.api.nvim_buf_line_count(pos.buf))
      pcall(vim.api.nvim_win_set_cursor, preview_win, { line, 0 })
      vim.api.nvim_win_call(preview_win, function()
        vim.cmd('normal! zz')
      end)
    end

    local group = vim.api.nvim_create_augroup('neotest-summary-preview', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      pattern = 'neotest-summary',
      callback = function(event)
        vim.api.nvim_create_autocmd('CursorMoved', {
          group = group,
          buffer = event.buf,
          callback = show_preview,
        })
        vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave', 'BufWinLeave' }, {
          group = group,
          buffer = event.buf,
          callback = close_preview,
        })
      end,
    })
  end,
}
