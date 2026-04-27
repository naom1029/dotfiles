-- memo.nvim
-- シンプルなメモ管理プラグイン（Telescope統合）
-- カテゴリ選択機能付き

local memo_dir = '~/.memo'
local categories = { 'work', 'personal', 'idea' }

return {
  'utouto97/memo.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'nvim-lua/plenary.nvim',
  },
  keys = {
    {
      '<leader>mn',
      function()
        local pickers = require('telescope.pickers')
        local finders = require('telescope.finders')
        local conf = require('telescope.config').values
        local actions = require('telescope.actions')
        local action_state = require('telescope.actions.state')

        local dir = vim.fn.expand(memo_dir)

        pickers
          .new({}, {
            prompt_title = 'Select Category',
            finder = finders.new_table({ results = categories }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, _)
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                local category = selection[1]
                local category_dir = dir .. '/' .. category

                vim.fn.mkdir(category_dir, 'p')

                local now = os.date('%Y%m%d_%H%M%S')
                local filepath = category_dir .. '/' .. now .. '.md'
                vim.cmd('edit ' .. filepath)
              end)
              return true
            end,
          })
          :find()
      end,
      desc = 'New memo (with category)',
    },
    {
      '<leader>mm',
      function()
        require('telescope.builtin').find_files({
          prompt_title = 'Search Memos',
          cwd = vim.fn.expand(memo_dir),
          hidden = false,
        })
      end,
      desc = 'Search memos (files)',
    },
    {
      '<leader>mg',
      function()
        require('telescope.builtin').live_grep({
          prompt_title = 'Grep Memos',
          cwd = vim.fn.expand(memo_dir),
        })
      end,
      desc = 'Search memos (grep)',
    },
  },
  config = function()
    require('memo').setup({
      memo_dir = memo_dir,
    })
  end,
}
