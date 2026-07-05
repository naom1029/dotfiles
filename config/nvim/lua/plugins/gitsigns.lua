-- gitsigns.nvim
-- Git変更をガターに表示し、Git操作を提供

return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '┃' },
      change = { text = '┃' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
      untracked = { text = '┆' },
    },
    signs_staged = {
      add = { text = '┃' },
      change = { text = '┃' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
      untracked = { text = '┆' },
    },
    signs_staged_enable = true,
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
      follow_files = true,
    },
    auto_attach = true,
    attach_to_untracked = false,
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol',
      delay = 300,
      ignore_whitespace = true,
      virt_text_priority = 100,
      use_focus = true,
    },
    sign_priority = 6,
    update_debounce = 100,
    max_file_length = 40000,
    preview_config = {
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1,
    },
    on_attach = function(bufnr)
      local gitsigns = require('gitsigns')

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']h', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gitsigns.nav_hunk('next')
        end
      end, { desc = 'Next hunk' })

      map('n', '[h', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gitsigns.nav_hunk('prev')
        end
      end, { desc = 'Previous hunk' })

      -- Actions
      map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'Git [s]tage hunk' })
      map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'Git [r]eset hunk' })
      map('v', '<leader>gs', function()
        gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = 'Git [s]tage hunk' })
      map('v', '<leader>gr', function()
        gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = 'Git [r]eset hunk' })
      map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'Git [S]tage buffer' })
      map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Git [R]eset buffer' })
      map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Git [p]review hunk' })
      map('n', '<leader>gi', gitsigns.preview_hunk_inline, { desc = 'Git [i]nline preview hunk' })
      map('n', '<leader>gb', function()
        gitsigns.blame_line({ full = true })
      end, { desc = 'Git [b]lame line' })

      -- Diff
      map('n', '<leader>gd', gitsigns.diffthis, { desc = 'Git [d]iff current file' })
    end,
  },
}
