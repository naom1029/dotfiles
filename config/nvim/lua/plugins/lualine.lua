-- lualine.nvim
-- リッチなステータスライン

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  opts = {
    options = {
      theme = 'auto',
      globalstatus = true,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = { statusline = { 'neo-tree', 'lazy', 'mason' } },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { { 'filename', path = 1 } },
      lualine_x = {
        -- overseerのタスク状況
        -- 'overseer'コンポーネント直書きだとlazy.nvimのrequire自動ロードで
        -- overseerが毎起動ロードされてしまうため、ロード済みの時だけ表示する
        {
          function()
            if not package.loaded['overseer'] then
              return ''
            end
            local tasks = require('overseer.task_list').list_tasks({ unique = true })
            local counts = {}
            for _, task in ipairs(tasks) do
              counts[task.status] = (counts[task.status] or 0) + 1
            end
            local parts = {}
            for _, s in ipairs({ 'RUNNING', 'SUCCESS', 'FAILURE' }) do
              if counts[s] then
                table.insert(parts, s:sub(1, 1) .. ':' .. counts[s])
              end
            end
            return table.concat(parts, ' ')
          end,
        },
        'encoding',
        'fileformat',
        'filetype',
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
  },
}
