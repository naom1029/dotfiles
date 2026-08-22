-- カラースキーム
-- 複数のカラースキームをインストールし、Telescopeで切り替え可能

return {
  -- arctic.nvim (フォールバックのデフォルト。VSCode Dark Modernの忠実な移植で、
  -- WezTerm側もこの配色に統一している。実際に使うのはこれだけなので唯一eager load)
  {
    'rockyzhang24/arctic.nvim',
    branch = 'v2',
    dependencies = { 'rktjmp/lush.nvim' },
    lazy = false,
    priority = 1000, -- 最優先で読み込み
    config = function()
      -- 保存されたカラースキームを読み込む（なければarcticをデフォルトに）
      local cache_dir = vim.fn.stdpath 'cache'
      local colorscheme_file = cache_dir .. '/colorscheme.txt'
      local file = io.open(colorscheme_file, 'r')
      local saved_colorscheme = nil

      if file then
        saved_colorscheme = file:read '*a'
        file:close()
        -- 改行を除去
        saved_colorscheme = saved_colorscheme:gsub('\n', '')
      end

      -- 保存されたカラースキームがあればそれを使用（空ファイル対策で空白以外の文字を要求）
      local colorscheme_to_load = (saved_colorscheme and saved_colorscheme:match('%S')) and saved_colorscheme
        or 'arctic'

      -- カラースキームを適用（エラーハンドリング付き）
      local ok = pcall(vim.cmd.colorscheme, colorscheme_to_load)
      if not ok then
        -- 失敗したらarcticにフォールバック
        vim.cmd.colorscheme 'arctic'
      end
    end,
  },

  -- kanagawa.nvim
  {
    'rebelot/kanagawa.nvim',
    lazy = true,
    opts = {
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      theme = 'dragon',
      background = {
        dark = 'dragon',
        light = 'lotus',
      },
    },
  },

  -- tokyonight.nvim (モダンで視認性が高い)
  -- 未使用時は遅延ロード。:colorscheme実行時にlazy.nvimが自動でロードする
  {
    'folke/tokyonight.nvim',
    lazy = true,
    opts = {
      style = 'night', -- night, storm, day, moon
      transparent = false,
      terminal_colors = true,
    },
  },

  -- catppuccin (パステル調で目に優しい)
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = true,
    opts = {
      flavour = 'mocha', -- latte, frappe, macchiato, mocha
      transparent_background = false,
    },
  },

  -- gruvbox (クラシックで温かみのある配色)
  {
    'ellisonleao/gruvbox.nvim',
    lazy = true,
    opts = {
      transparent_mode = false,
    },
  },

  -- rose-pine (落ち着いた雰囲気)
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = true,
    opts = {
      variant = 'moon', -- auto, main, moon, dawn
      disable_background = false,
    },
  },
}
