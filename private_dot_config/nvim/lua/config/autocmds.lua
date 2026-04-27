-- Autocommands設定
-- イベントハンドラーの定義

-- テキストのyank時にハイライト
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- カラースキーム変更時に自動保存
vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Save colorscheme selection for next session',
  group = vim.api.nvim_create_augroup('colorscheme-persist', { clear = true }),
  callback = function()
    local colorscheme = vim.g.colors_name
    if colorscheme then
      local cache_dir = vim.fn.stdpath 'cache'
      local colorscheme_file = cache_dir .. '/colorscheme.txt'
      local file = io.open(colorscheme_file, 'w')
      if file then
        file:write(colorscheme)
        file:close()
      end
    end
  end,
})

-- 挿入モードを抜けたときに自動保存（変更があるときのみ）
vim.api.nvim_create_autocmd('InsertLeave', {
  desc = 'Auto-save file when leaving insert mode',
  group = vim.api.nvim_create_augroup('auto-save-insert', { clear = true }),
  callback = function(ev)
    -- ファイルバッファ以外は除外（help/terminal/prompt など）
    if vim.bo[ev.buf].buftype ~= '' then
      return
    end

    -- 読み取り専用または変更不可の場合はスキップ
    if vim.bo[ev.buf].readonly or not vim.bo[ev.buf].modifiable then
      return
    end

    -- 無名バッファは除外
    local name = vim.api.nvim_buf_get_name(ev.buf)
    if name == nil or name == '' then
      return
    end

    -- update は変更があるときだけ保存（write より効率的）
    vim.cmd('silent! update')
  end,
})

-- カーソルを止めたときに診断をフローティングウィンドウで表示（カーソル位置に診断がある場合のみ）
vim.api.nvim_create_autocmd('CursorHold', {
  desc = 'Show diagnostics in floating window at cursor position',
  group = vim.api.nvim_create_augroup('lsp-diagnostics-float', { clear = true }),
  callback = function()
    -- カーソル位置を取得
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line = cursor[1] - 1
    local col = cursor[2]

    -- 現在の行の診断を取得
    local diagnostics = vim.diagnostic.get(0, { lnum = line })

    -- カーソル位置が診断の範囲内にあるかチェック
    for _, diagnostic in ipairs(diagnostics) do
      if col >= diagnostic.col and col <= (diagnostic.end_col or diagnostic.col) then
        vim.diagnostic.open_float(nil, { focusable = false })
        return
      end
    end
  end,
})
