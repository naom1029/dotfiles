-- git-worktree.nvim
-- Git worktree 管理を Neovim 内で効率的に行うプラグイン
-- Telescope 統合により、worktree の作成・切り替え・削除が簡単に

return {
  'ThePrimeagen/git-worktree.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  keys = {
    {
      '<leader>wl',
      function()
        require('telescope').extensions.git_worktree.git_worktrees()
      end,
      desc = '[W]orktree [L]ist - 一覧・切り替え',
    },
    {
      '<leader>wc',
      function()
        require('telescope').extensions.git_worktree.create_git_worktree()
      end,
      desc = '[W]orktree [C]reate - 新規作成',
    },
  },
  config = function()
    local worktree = require('git-worktree')

    worktree.setup({
      change_directory_command = 'cd',
      update_on_change = false,
      clearjumps_on_change = true,
      autopush = false,
    })

    require('telescope').load_extension('git_worktree')

    worktree.on_tree_change(function(op, metadata)
      if op == worktree.Operations.Switch then
        vim.schedule(function()
          -- 全バッファを閉じる
          vim.cmd('silent! %bdelete!')

          -- カレントディレクトリを worktree に変更
          vim.fn.chdir(metadata.path)

          -- Neo-tree を開く（フォーカスする）
          vim.cmd('Neotree filesystem focus')

          vim.notify('Switched to: ' .. metadata.path, vim.log.levels.INFO)
        end)
      elseif op == worktree.Operations.Create then
        vim.notify('Worktree created: ' .. metadata.path, vim.log.levels.INFO)
      elseif op == worktree.Operations.Delete then
        vim.notify('Worktree deleted: ' .. metadata.path, vim.log.levels.INFO)
      end
    end)

    -- LazyGit との統合強化
    -- LazyGit 終了時に worktree の状態を確認
    vim.api.nvim_create_autocmd('TermClose', {
      pattern = '*lazygit',
      callback = function()
        -- ファイル変更を検知
        vim.cmd('checktime')

        -- worktree が切り替わった可能性があるため、cwd を確認
        local current_dir = vim.fn.getcwd()
        vim.notify('Current directory: ' .. current_dir, vim.log.levels.DEBUG)
      end,
    })
  end,
}
