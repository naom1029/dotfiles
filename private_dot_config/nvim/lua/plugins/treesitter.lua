-- nvim-treesitter
-- シンタックスハイライト、編集、コードナビゲーション

return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs',
  opts = {
    ensure_installed = {
      'bash',
      'c',
      'diff',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'vim',
      'vimdoc',
    },
    -- インストールされていない言語を自動インストール
    auto_install = true,
    highlight = {
      enable = true,
      -- Rubyなどはvimの正規表現ハイライトに依存
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = {
      enable = true,
      disable = { 'ruby' },
    },
  },
}
