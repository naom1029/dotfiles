-- neotest
-- VSCodeのTestingパネル相当。個々のテストの実行・ツリー表示・デバッグを行う
-- 対応言語: Python, Lua(plenary/busted), C++(GoogleTest), TypeScript/JavaScript(Jest/Vitest)
-- Rustは見送り（rustaceanvimはLSP管理を丸ごと引き取る仕様のため別途検討）

-- GoogleTestは実行にコンパイル済みバイナリが必要なため、neotest-gtestは
-- テストファイルごとに対応する実行ファイルを事前に知っている必要がある
-- （:ConfigureGtestで手動登録するのが公式の方法）。
-- 多くのCMake/gtestプロジェクトは「テストファイル名 == ビルドディレクトリ配下の
-- 同名実行ファイル」という規約に従うため、テスト実行のたびにこの規約で自動
-- マッピングし直すことで手動登録を省略できる（冪等なので毎回呼んでも安全、
-- ファイルが増えても都度自動で拾われる）。
--
-- プロジェクトの規約がこれと違う場合は下の gtest_conventions を編集する:
--   - bin_dirs: 実行ファイルを探すルートからの相対ディレクトリ候補（先頭から順に探索）
--   - executable_name: テストファイルの絶対パスから実行ファイル名を計算する関数
--     （デフォルトは拡張子を除いたベース名。命名規則が違うプロジェクトはここを
--     プロジェクトのルートパスで分岐させて上書きする）
local gtest_conventions = {
  -- CMakeのRUNTIME_OUTPUT_DIRECTORY未設定時はソース側のCMakeLists.txtの場所を
  -- そのままビルドディレクトリ配下に反映する（例: tests/CMakeLists.txt定義 →
  -- build/tests/配下）ため、bin付き/なし・testsサブディレクトリ付きを網羅する
  bin_dirs = {
    'build/bin',
    'build/bin/tests',
    'build/tests',
    'build/test',
    'build',
    'cmake-build-debug/bin',
    'cmake-build-release/bin',
  },
  executable_name = function(test_file)
    return vim.fn.fnamemodify(test_file, ':t:r')
  end,
  -- discoveryの探索対象から除外するディレクトリ名。neotest-gtestはデフォルトで
  -- 一切除外しないため、CMakeのビルド生成物・vendorされた依存ソース
  -- （例: build/_deps/googletest-src配下に大量のGoogleTest自身のテストが
  -- ある）まで巻き込んでdiscoveryが極端に遅くなる／無関係なテストが
  -- 混ざる。ここに列挙したディレクトリ名は丸ごとスキップする。
  exclude_dirs = {
    build = true,
    ['_deps'] = true,
    ['.git'] = true,
    ['cmake-build-debug'] = true,
    ['cmake-build-release'] = true,
    node_modules = true,
  },
}

local function is_excluded_path(path)
  for segment in path:gmatch('[^/]+') do
    if gtest_conventions.exclude_dirs[segment] then
      return true
    end
  end
  return false
end

-- neotest-gtestの実行ファイル対応表は ~/.local/share/nvim/neotest-gtest/<rootを
-- エンコードした名前>.json に保存される（:ConfigureGtestが書き込む先と同じ）。
-- neotest-gtestの生きたAPI(ExecutablesRegistry等)はneotestの内部ポジション
-- ツリーが構築済みであることを前提にしており、かつnio(非同期)コンテキストが
-- 必要で、事前にツリーが無いと"tree with root ... not found"で失敗したり
-- 大規模プロジェクトでdiscoveryが極端に遅くなる（試した結果、実際にハング
-- することを確認した）。そのため生きたAPIは一切呼ばず、このJSON永続化
-- ファイルを直接読み書きする。フォーマットが変わったら効かなくなるだけで、
-- 影響は「自動化されない（:ConfigureGtestの手動登録に戻る）」のみに留まる。
local function gtest_storage_path(root)
  local storage_dir = vim.fn.stdpath('data') .. '/neotest-gtest'
  local encoded = root:gsub('%%', '%%1'):gsub('/', '%%0')
  return storage_dir .. '/' .. encoded .. '.json'
end

local function auto_map_gtest_executables()
  local ok_cfg, gtest_config = pcall(require, 'neotest-gtest.config')
  if not ok_cfg then
    return
  end

  local candidate_paths = {}
  local cur_file = vim.fn.expand('%:p')
  if cur_file ~= '' and (vim.bo.filetype == 'cpp' or vim.bo.filetype == 'c') then
    table.insert(candidate_paths, cur_file)
  end
  table.insert(candidate_paths, vim.fn.getcwd() .. '/.')

  local roots = {}
  for _, path in ipairs(candidate_paths) do
    local ok_root, root = pcall(gtest_config.root, path)
    if ok_root and root and not roots[root] then
      roots[root] = true
    end
  end

  for root in pairs(roots) do
    local test_files = vim.fn.globpath(root, '**/*_test.*', true, true)
    vim.list_extend(test_files, vim.fn.globpath(root, '**/test_*.*', true, true))

    local mapping = {}
    for _, file in ipairs(test_files) do
      if not is_excluded_path(file:sub(#root + 2)) and gtest_config.is_test_file(file) then
        local exe_name = gtest_conventions.executable_name(file)
        for _, bin_dir in ipairs(gtest_conventions.bin_dirs) do
          local candidate = root .. '/' .. bin_dir .. '/' .. exe_name
          if vim.fn.executable(candidate) == 1 then
            mapping[file] = candidate
            break
          end
        end
      end
    end
    if next(mapping) == nil then
      goto continue
    end

    local storage_path = gtest_storage_path(root)
    vim.fn.mkdir(vim.fn.fnamemodify(storage_path, ':h'), 'p')

    local data = { node2executable = {} }
    if vim.fn.filereadable(storage_path) == 1 then
      local ok_read, decoded = pcall(vim.json.decode, table.concat(vim.fn.readfile(storage_path), '\n'))
      if ok_read and type(decoded) == 'table' then
        data = decoded
        data.node2executable = data.node2executable or {}
      end
    end
    for file, exe in pairs(mapping) do
      data.node2executable[file] = exe
    end
    vim.fn.writefile({ vim.json.encode(data) }, storage_path)
    ::continue::
  end
end

return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-python',
    'nvim-neotest/neotest-plenary',
    'alfaix/neotest-gtest',
    'nvim-neotest/neotest-jest',
    'marilari88/neotest-vitest',
  },
  keys = {
    {
      '<leader>nt',
      function()
        auto_map_gtest_executables()
        require('neotest').run.run()
      end,
      desc = 'Test: 最も近いテストを実行',
    },
    {
      '<leader>nT',
      function()
        auto_map_gtest_executables()
        require('neotest').run.run(vim.fn.expand('%'))
      end,
      desc = 'Test: 現在ファイルのテストを実行',
    },
    {
      '<leader>nA',
      function()
        auto_map_gtest_executables()
        require('neotest').run.run({ suite = true })
      end,
      desc = 'Test: プロジェクト全体のテストを実行',
    },
    {
      '<leader>nd',
      function()
        auto_map_gtest_executables()
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
      },
      adapters = {
        require('neotest-python')({
          dap = { justMyCode = false },
        }),
        require('neotest-plenary'),
        require('neotest-gtest').setup({
          filter_dir = function(name)
            return not gtest_conventions.exclude_dirs[name]
          end,
        }),
        require('neotest-jest')({}),
        require('neotest-vitest'),
      },
    }
  end,
  config = function(_, opts)
    -- neotest-gtestが非推奨のvim.tbl_flatten()を呼んでおり(neotest_adapter.lua内、
    -- upstream最新コミットでも未修正)、その非推奨警告(vim.deprecate→nvim_echo)が
    -- 非同期の安全でないコンテキストから呼ばれてクラッシュする(E5560)。
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

    -- neotest-gtestがQuery:iter_matches()に`all = false`を渡している。
    -- このオプションはNeovim 0.12で削除された（:h news-removed）ため、
    -- 各キャプチャがノード単体ではなくノードのリストで返るようになり、
    -- get_node_text()や:range()が「attempt to call method 'start'」で落ちて
    -- テスト検出が丸ごと失敗する（＝実行してもテスト0件になる）。
    -- `all = false`を渡す旧来の呼び出しに対してだけ、削除前の挙動
    -- （キャプチャごとに最後のノードのみを返す）を復元する。
    local probe = vim.treesitter.query.parse('lua', '((identifier) @id)')
    local Query = getmetatable(probe)
    local orig_iter_matches = Query.iter_matches
    Query.iter_matches = function(self, node, source, start, stop, iter_opts)
      local iter = orig_iter_matches(self, node, source, start, stop, iter_opts)
      if not (iter_opts and iter_opts.all == false) then
        return iter
      end
      return function()
        local pattern, match, metadata = iter()
        if pattern == nil then
          return nil
        end
        local unwrapped = {}
        for id, nodes in pairs(match) do
          unwrapped[id] = type(nodes) == 'table' and nodes[#nodes] or nodes
        end
        return pattern, unwrapped, metadata
      end
    end

    require('neotest').setup(opts)
  end,
}
