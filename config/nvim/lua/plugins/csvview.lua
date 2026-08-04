-- csvview.nvim
-- CSV/TSVを仮想テキストで表形式に整列表示する。
-- 整列は virtual text で行うためファイルの内容は書き換えられない。

return {
  'hat0uma/csvview.nvim',
  ft = { 'csv', 'tsv' },
  cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle', 'CsvViewInfo' },
  keys = {
    { '<leader>ut', '<cmd>CsvViewToggle<cr>', desc = '[U]I: Toggle CSV [T]able view' },
    {
      '<leader>cv',
      function()
        -- csvview には列の固定・非表示機能が無く、横に長いCSVは追いきれない。
        -- csvlens なら --columns で表示列を絞れるため、外部ビューアに委ねる。
        local file = vim.api.nvim_buf_get_name(0)
        if file == '' then
          vim.notify('ファイルが保存されていません', vim.log.levels.WARN)
          return
        end
        require('toggleterm.terminal').Terminal
          :new({
            cmd = 'csvlens -d auto ' .. vim.fn.shellescape(file),
            direction = 'float',
            close_on_exit = true,
            hidden = true,
          })
          :toggle()
      end,
      desc = '[C]ode: CSV [V]iewer (csvlens)',
      ft = { 'csv', 'tsv' },
    },
  },
  dependencies = { 'akinsho/toggleterm.nvim' },
  opts = {
    parser = {
      comments = { '#', '//' },
    },
    view = {
      -- highlight: 区切り文字を色分け / border: │ で罫線として描画
      display_mode = 'border',
      -- ヘッダー行を画面上部に固定
      sticky_header = {
        enabled = true,
      },
    },
    -- csvview 有効時のみバッファローカルに設定される。
    -- if/af は mini.ai の関数テキストオブジェクトと綴りが重なるが、
    -- CSVバッファでは関数の概念が無いため実質的な衝突にはならない。
    keymaps = {
      textobject_field_inner = { 'if', mode = { 'o', 'x' } },
      textobject_field_outer = { 'af', mode = { 'o', 'x' } },
      -- Excel風の横移動
      jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
      jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
    },
  },
}
