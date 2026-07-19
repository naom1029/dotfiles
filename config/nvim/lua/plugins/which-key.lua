-- which-key.nvim
-- ペンディング中のキーバインドを表示

return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    delay = 0,
    -- Neovim 標準のブラケットモーション（]b/]q/]m 等）を which-key 表示から隠す。
    -- キーマップ自体は有効なまま。自分で定義した ]a/]r/]t/]h/]d は残す。
    filter = function(mapping)
      local desc = mapping.desc or ''
      -- 日本語（非 ASCII）を含む desc はプラグイン由来 → 残す
      if desc:match('[\128-\255]') then
        return true
      end
      -- gitsigns hunk / 診断は残す
      if desc:lower():match('hunk') or desc:match('[Dd]iagnostic') then
        return true
      end
      -- 上記以外で [ または ] 始まりのキー（Neovim 標準ブラケット）は隠す
      local lhs = mapping.lhs or ''
      if lhs:match('^[%[%]]') then
        return false
      end
      return true
    end,
    icons = {
      mappings = vim.g.have_nerd_font,
      keys = vim.g.have_nerd_font and {} or {
        Up = '<Up> ',
        Down = '<Down> ',
        Left = '<Left> ',
        Right = '<Right> ',
        C = '<C-…> ',
        M = '<M-…> ',
        D = '<D-…> ',
        S = '<S-…> ',
        CR = '<CR> ',
        Esc = '<Esc> ',
        ScrollWheelDown = '<ScrollWheelDown> ',
        ScrollWheelUp = '<ScrollWheelUp> ',
        NL = '<NL> ',
        BS = '<BS> ',
        Space = '<Space> ',
        Tab = '<Tab> ',
        F1 = '<F1>',
        F2 = '<F2>',
        F3 = '<F3>',
        F4 = '<F4>',
        F5 = '<F5>',
        F6 = '<F6>',
        F7 = '<F7>',
        F8 = '<F8>',
        F9 = '<F9>',
        F10 = '<F10>',
        F11 = '<F11>',
        F12 = '<F12>',
      },
    },
    -- キーチェーンのドキュメント
    spec = {
      { '<leader>a', group = '[A]I/Claude Code' },
      { '<leader>b', group = '[B]uffer' },
      { '<leader>c', group = '[C]ode' , mode = { 'n', 'x' } },
      { '<leader>d', group = '[D]ebug' },
      { '<leader>f', group = '[F]ile' },
      { '<leader>g', group = '[G]it' },
      { '<leader>m', group = '[M]emo' },
      { '<leader>p', group = '[P]roject' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]erminal' },
      { '<leader>u', group = '[U]I/Toggle' },
      { '<leader>w', group = '[W]orktree' },
      { '<leader>x', group = 'Diagnostics/Quickfix' },
    },
  },
}
