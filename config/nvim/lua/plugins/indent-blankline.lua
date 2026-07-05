-- indent-blankline.nvim (ibl.nvim)
-- インデントガイドを表示するプラグイン

return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    -- レインボーカラー定義
    local highlight = {
      'RainbowRed',
      'RainbowYellow',
      'RainbowBlue',
      'RainbowOrange',
      'RainbowGreen',
      'RainbowViolet',
      'RainbowCyan',
    }

    -- ハイライトグループの登録
    local hooks = require('ibl.hooks')
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
      vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
      vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
      vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
      vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
      vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
      vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
    end)

    -- ibl セットアップ
    require('ibl').setup({
      indent = {
        char = '│',
        highlight = highlight, -- レインボーインデント有効化
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = false,
      },
      whitespace = {
        remove_blankline_trail = true,
      },
    })
  end,
}
