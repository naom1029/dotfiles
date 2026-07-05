-- カラースキーム
-- 複数のカラースキームをインストールし、Telescopeで切り替え可能

return {
  -- kanagawa.nvim (フォールバックのデフォルト)
  {
    'rebelot/kanagawa.nvim',
    priority = 1000, -- 最優先で読み込み
    config = function()
      require('kanagawa').setup {
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = true,
        dimInactive = false,
        terminalColors = true,
        theme = 'dragon',
        background = {
          dark = 'dragon',
          light = 'lotus',
        },
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = 'none',
              },
            },
          },
        },
        overrides = function(colors)
          local theme = colors.theme
          return {
            NormalFloat = { bg = 'none' },
            FloatBorder = { bg = 'none' },
            FloatTitle = { bg = 'none' },
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
            PmenuSel = { fg = 'NONE', bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
          }
        end,
      }

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

      -- 保存されたカラースキームがあればそれを使用、なければarcticをデフォルトに
      local colorscheme_to_load = saved_colorscheme or 'arctic'

      -- カラースキームを適用（エラーハンドリング付き）
      local ok = pcall(vim.cmd.colorscheme, colorscheme_to_load)
      if not ok then
        -- 失敗したらkanagawa-dragonにフォールバック
        vim.cmd.colorscheme 'kanagawa-dragon'
      end
    end,
  },

  -- tokyonight.nvim (モダンで視認性が高い)
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 900,
    opts = {
      style = 'night', -- night, storm, day, moon
      transparent = true,
      terminal_colors = true,
    },
  },

  -- catppuccin (パステル調で目に優しい)
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 900,
    opts = {
      flavour = 'mocha', -- latte, frappe, macchiato, mocha
      transparent_background = true,
    },
  },

  -- gruvbox (クラシックで温かみのある配色)
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 900,
    opts = {
      transparent_mode = true,
    },
  },

  -- rose-pine (落ち着いた雰囲気)
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 900,
    opts = {
      variant = 'moon', -- auto, main, moon, dawn
      disable_background = true,
    },
  },

  -- arctic.nvim
  {
    'rockyzhang24/arctic.nvim',
    branch = 'v2',
    lazy = false,
    priority = 900,
    dependencies = { 'rktjmp/lush.nvim' },
  },
}
