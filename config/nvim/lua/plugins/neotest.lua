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
        require('neotest').summary.toggle({ enter = true })
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
          client.listeners.results = function(_, results, partial)
            -- partialは実行途中の部分結果なので、完了時だけ見る
            if partial then
              return
            end
            -- neotest-ctestは ctest を --quiet --output-on-failure で実行するため
            -- 成功時の出力は空になる。空のパネルを開いても意味がないので、
            -- 失敗が含まれるときだけ開く（成功はツリーとサインカラムの✓で分かる）
            local has_failure = false
            for _, result in pairs(results) do
              if result.status == 'failed' then
                has_failure = true
                break
              end
            end
            if not has_failure then
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

    -- ツリーでカーソルが乗っているテストのコードをフロートでプレビューする
    -- （VSCodeのTest Explorerのシングルクリック=プレビュータブに相当。
    -- ホバーだけでは開かず、明示的なキー（p）を押したときだけ表示する。
    -- 別の行でpを押すと同じプレビューを置き換える＝タブが増え続けない）。
    -- neotestは「カーソル行→テスト位置」の対応を公開APIで提供していないため、
    -- jumptoのコールバックを流用する。ジャンプ処理の実体である
    -- lib.ui.open_buf を一時的に差し替えて、ウィンドウを切り替えず
    -- 対象バッファと行だけを受け取る。
    local preview_win = nil
    local preview_buf = nil
    local preview_line = nil

    -- プレビューのためだけに読み込んだバッファ（他のウィンドウに表示されておらず、
    -- 未編集）は用済みになったら削除する。VSCodeのプレビュータブが実タブに
    -- 昇格しない限り自動で閉じられるのと同じ挙動。すでに他の場所で開かれている
    -- バッファ（bufwinidが取れる）や編集中のバッファは対象外にして安全側に倒す。
    local function cleanup_stale_preview_buf(bufnr)
      if
        bufnr
        and vim.api.nvim_buf_is_valid(bufnr)
        and vim.fn.bufwinid(bufnr) == -1
        and not vim.bo[bufnr].modified
      then
        pcall(vim.api.nvim_buf_delete, bufnr, { unload = false })
      end
    end

    local function close_preview()
      if preview_win and vim.api.nvim_win_is_valid(preview_win) then
        vim.api.nvim_win_close(preview_win, true)
      end
      preview_win = nil
      cleanup_stale_preview_buf(preview_buf)
      preview_buf = nil
      preview_line = nil
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
      -- 本物のjumptoコールバックは対象ファイルを初めて読むとき vim.fn.bufload() で
      -- BufReadPostを発火させる。その瞬間はまだツリー側がカレントウィンドウのため、
      -- Neovim組み込みの「最後のカーソル位置へ復元」autocmd（:h restore-cursor）が
      -- window 0 = ツリー側に対して nvim_win_set_cursor を実行し、ツリーのカーソルを
      -- 対象ファイルの最終編集行へ飛ばしてしまう。プレビューはただの下見なので
      -- ここではautocmdを止めて副作用を防ぐ。
      local saved_eventignore = vim.o.eventignore
      vim.o.eventignore = 'all'
      for _, map in ipairs(vim.api.nvim_buf_get_keymap(0, 'n')) do
        if map.callback and map.desc and map.desc:match('^jumpto') then
          pcall(map.callback)
          break
        end
      end
      vim.o.eventignore = saved_eventignore
      lib.ui.open_buf = orig_open_buf
      return captured
    end

    -- lib.ui.open_bufを差し替えている間はneotest本来の読み込み処理が走らないため、
    -- ファイルが読み込まれていてもfiletypeが未設定でtreesitterハイライトが
    -- 起動しないままになる。表示前に明示的に検出・設定してFileTypeを発火させる
    -- （Enterで実際に開いたときも同じバッファを使うため、ここで直しておけば
    -- 以後ハイライトが効く）。
    local function ensure_highlighted(bufnr)
      if not vim.api.nvim_buf_is_loaded(bufnr) then
        vim.fn.bufload(bufnr)
      end
      if vim.bo[bufnr].filetype == '' then
        local ft = vim.filetype.match({ buf = bufnr })
        if ft then
          vim.bo[bufnr].filetype = ft
        end
      end
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
      -- 同じ対象で再度pを押したらトグルで閉じる
      if
        preview_win
        and vim.api.nvim_win_is_valid(preview_win)
        and preview_buf == pos.buf
        and preview_line == pos.line
      then
        close_preview()
        return
      end
      -- 別のファイルに切り替える場合、直前のプレビュー専用バッファは用済みなので掃除する
      if preview_buf and preview_buf ~= pos.buf then
        cleanup_stale_preview_buf(preview_buf)
      end
      preview_buf = pos.buf
      preview_line = pos.line
      ensure_highlighted(pos.buf)

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
        vim.keymap.set('n', 'p', show_preview, {
          buffer = event.buf,
          nowait = true,
          desc = 'neotest: プレビュー',
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
