-- nvim-treesitter
-- シンタックスハイライト、編集、コードナビゲーション
-- main ブランチ版（master は 2025-05 に凍結、Neovim 0.12+ 非対応）

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  lazy = false,
  config = function()
    -- Neovim 0.12 で match[id] がリストを返すようになった問題のワークアラウンド
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/8636
    local ok, qp = pcall(require, 'nvim-treesitter.query_predicates')
    if ok then
      local query = require('vim.treesitter.query')
      local function get_node(match, id)
        local val = match[id]
        if not val then
          return nil
        end
        if type(val) == 'table' then
          return val[1]
        end
        return val
      end

      local opts = { force = true, all = false }

      query.add_directive('set-lang-from-info-string!', function(match, _, bufnr, pred, metadata)
        local node = get_node(match, pred[2])
        if not node then
          return
        end
        local text = vim.treesitter.get_node_text(node, bufnr):lower()
        local ft_match = vim.filetype.match({ filename = 'a.' .. text })
        metadata['injection.language'] = ft_match or text
      end, opts)

      query.add_directive('downcase!', function(match, _, bufnr, pred, metadata)
        local node = get_node(match, pred[2])
        if not node then
          return
        end
        local id = pred[2]
        local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ''
        if not metadata[id] then
          metadata[id] = {}
        end
        metadata[id].text = text:lower()
      end, opts)
    end

    local ensure_installed = {
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
