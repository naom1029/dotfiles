-- overseer.nvim
-- タスクランナー。.vscode/tasks.json を自動で読み込み（VSCode タスク互換）。
--
-- VSCode 準拠の操作感:
--   <C-S-b>       : ビルドグループのタスクを実行（VSCode の Ctrl+Shift+B 相当）
--   :OverseerRun  : 全タスクから選択実行（コマンドパレット「Tasks: Run Task」相当）
--   :OverseerToggle : 実行状況/出力パネルのトグル

return {
  'stevearc/overseer.nvim',
  cmd = { 'OverseerRun', 'OverseerToggle', 'OverseerQuickAction', 'OverseerRunCmd', 'OverseerInfo' },
  keys = {
    {
      '<F6>',
      function()
        -- 全タスクから実行（該当が1つなら即実行、複数なら選択）。
        -- overseer は cppbuild type 非対応のため build タグ限定にはしない。
        require('overseer').run_task({})
      end,
      desc = 'タスク実行 (Overseer)',
    },
  },
  opts = {},
}
