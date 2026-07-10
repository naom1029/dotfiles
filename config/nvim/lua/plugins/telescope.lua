-- telescope.nvim
-- ファジーファインダー（ファイル、LSP、その他）

return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = 'master',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons' },
  },
  config = function()
    require('telescope').setup {
      defaults = {
        -- 普段はインサートモード開始
        initial_mode = 'insert',
      },
      -- LSP系のピッカーだけノーマルモード開始にして誤操作を防ぐ
      pickers = {
        lsp_definitions = { initial_mode = 'normal' },
        lsp_references = { initial_mode = 'normal' },
        lsp_implementations = { initial_mode = 'normal' },
        lsp_type_definitions = { initial_mode = 'normal' },
        lsp_document_symbols = { initial_mode = 'normal' },
        lsp_dynamic_workspace_symbols = { initial_mode = 'normal' },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Telescope拡張機能を有効化
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- キーマップ設定
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>st', builtin.builtin, { desc = '[S]earch [T]elescope builtin' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sD', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>so', builtin.oldfiles, { desc = '[S]earch [O]ld files' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    -- 現在のバッファ内をファジー検索
    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- 開いているファイル内をlive grep
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Neovim設定ファイル内を検索
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })

    -- カラースキームをプレビューしながら切り替え
    vim.keymap.set('n', '<leader>sc', builtin.colorscheme, { desc = '[S]earch [C]olorscheme' })

    -- ghq + workspace リポジトリを選んで開く
    vim.keymap.set('n', '<leader>pp', function()
      local pickers = require 'telescope.pickers'
      local finders = require 'telescope.finders'
      local conf = require('telescope.config').values
      local actions = require 'telescope.actions'
      local action_state = require 'telescope.actions.state'

      local repos = {}
      local ghq_root = vim.fn.systemlist('ghq root')[1]
      if ghq_root and ghq_root ~= '' then
        for _, path in ipairs(vim.fn.systemlist('ghq list --full-path')) do
          table.insert(repos, path)
        end
      end
      for _, path in ipairs(vim.fn.globpath(vim.fn.expand('~/workspace'), '*', false, true)) do
        if vim.fn.isdirectory(path) == 1 then
          table.insert(repos, path)
        end
      end

      pickers
        .new({}, {
          prompt_title = 'Projects',
          finder = finders.new_table { results = repos },
          sorter = conf.generic_sorter {},
          attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              if selection then
                vim.cmd('silent! SessionSave')
                vim.cmd('silent! %bdelete!')
                vim.cmd('cd ' .. selection[1])
                vim.cmd('silent! SessionRestore')
                vim.notify('cd ' .. selection[1], vim.log.levels.INFO)
              end
            end)
            return true
          end,
        })
        :find()
    end, { desc = '[P]roject [P]ick - ghq/workspace' })
  end,
}
