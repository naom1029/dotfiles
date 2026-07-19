-- nvim-treesitter
-- シンタックスハイライト、編集、コードナビゲーション
-- main ブランチ版（master は 2025-05 に凍結、Neovim 0.12+ 非対応）

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  lazy = false,
  config = function()
    local ensure_installed = {
      'bash',
      'c',
      'cpp',
      'css',
      'diff',
      'dockerfile',
      'gitcommit',
      'gitignore',
      'go',
      'html',
      'javascript',
      'jsdoc',
      'json',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'python',
      'query',
      'regex',
      'rust',
      'scss',
      'sql',
      'toml',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'yaml',
    }
    require('nvim-treesitter').install(ensure_installed)

    -- main ブランチはハイライト/インデントを自動で有効化しないため FileType で起動する
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
      callback = function(args)
        local buf = args.buf
        -- Rubyはvimの正規表現ハイライト・インデントに依存
        if vim.bo[buf].filetype == 'ruby' then
          return
        end
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
        if lang and pcall(vim.treesitter.start, buf, lang) then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
