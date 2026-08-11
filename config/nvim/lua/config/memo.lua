-- メモ管理
-- 日次の予実メモ（:MemoToday）とカテゴリ付きメモの作成・検索

local memo_dir = '~/.memo'
local categories = { 'work', 'personal', 'idea' }

-- 今日の予実メモ（日次1ファイル）を開く。無ければ予定/実績テンプレ付きで作成
vim.api.nvim_create_user_command('MemoToday', function()
  local daily_dir = vim.fn.expand(memo_dir) .. '/daily'
  vim.fn.mkdir(daily_dir, 'p')

  local date = os.date('%Y-%m-%d')
  local filepath = daily_dir .. '/' .. date .. '.md'
  local is_new = vim.fn.filereadable(filepath) == 0

  vim.cmd.edit(vim.fn.fnameescape(filepath))

  if is_new then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
      '# ' .. date,
      '',
      '## 予定',
      '',
      '## 実績',
      '',
    })
  end
end, { desc = "Open today's 予実 memo" })

vim.keymap.set('n', '<leader>md', '<cmd>MemoToday<cr>', { desc = "Open today's 予実 memo" })

vim.keymap.set('n', '<leader>mn', function()
  vim.ui.select(categories, { prompt = 'Select Category' }, function(category)
    if not category then
      return
    end
    local category_dir = vim.fn.expand(memo_dir) .. '/' .. category
    vim.fn.mkdir(category_dir, 'p')

    local filepath = category_dir .. '/' .. os.date('%Y%m%d_%H%M%S') .. '.md'
    vim.cmd.edit(vim.fn.fnameescape(filepath))
  end)
end, { desc = 'New memo (with category)' })

vim.keymap.set('n', '<leader>mm', function()
  require('telescope.builtin').find_files({
    prompt_title = 'Search Memos',
    cwd = vim.fn.expand(memo_dir),
    hidden = false,
  })
end, { desc = 'Search memos (files)' })

vim.keymap.set('n', '<leader>mg', function()
  require('telescope.builtin').live_grep({
    prompt_title = 'Grep Memos',
    cwd = vim.fn.expand(memo_dir),
  })
end, { desc = 'Search memos (grep)' })
