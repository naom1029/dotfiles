-- lazygit.nvim - LazyGit統合プラグイン
-- 高速で使いやすいGit TUI（Terminal User Interface）を提供
return {
  'kdheepak/lazygit.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim', -- ファイル操作ユーティリティ
  },
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  keys = {
    { '<leader>gl', '<cmd>LazyGit<cr>', desc = 'LazyGit を開く' },
    { '<leader>gc', '<cmd>LazyGitConfig<cr>', desc = 'LazyGit 設定を開く' },
    { '<leader>gf', '<cmd>LazyGitCurrentFile<cr>', desc = '現在のファイルで LazyGit' },
  },
  config = function()
    -- lazygitが浮動ウィンドウで開くよう設定
    vim.g.lazygit_floating_window_winblend = 0 -- 透明度（0 = 不透明）
    vim.g.lazygit_floating_window_scaling_factor = 0.9 -- ウィンドウサイズ（90%）
    vim.g.lazygit_floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' } -- ボーダー
    vim.g.lazygit_use_neovim_remote = 1 -- Neovimリモート編集を有効化

    -- カスタムコンフィグパスを設定（必要に応じて）
    vim.g.lazygit_use_custom_config_file_path = 0 -- カスタムコンフィグを使用しない

    -- LazyGit終了時にNeovimに戻る（git-worktree統合）
    vim.api.nvim_create_autocmd('TermClose', {
      pattern = '*lazygit',
      callback = function()
        -- ファイルの変更を検知
        vim.cmd('checktime')

        -- Git状態の変更を通知（worktreeの切り替えやブランチ変更に対応）
        vim.defer_fn(function()
          -- バッファをリロード
          vim.cmd('checktime')

          -- Gitsignsがインストールされている場合はリフレッシュ
          pcall(function()
            vim.cmd('Gitsigns refresh')
          end)

          -- Neo-treeがインストールされている場合はリフレッシュ
          pcall(function()
            vim.cmd('Neotree refresh')
          end)

          -- 現在のGitブランチを確認して通知
          local branch = vim.fn.system('git branch --show-current 2>/dev/null'):gsub('\n', '')
          if branch ~= '' then
            vim.notify('Current branch: ' .. branch, vim.log.levels.INFO)
          end
        end, 100) -- 100ms後に実行（LazyGitの終了処理を待つ）
      end,
    })
  end,
}