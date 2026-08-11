-- LSP 設定（Neovim 0.12 対応）

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'hrsh7th/cmp-nvim-lsp',
    'b0o/schemastore.nvim', -- JSON schemas
  },
  config = function()
    -- Mason セットアップ
    require('mason').setup()

    -- LSP アタッチ時のキーマップ設定
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- キーマップ
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('gy', require('telescope.builtin').lsp_type_definitions, '[G]oto t[Y]pe definition')
        map('<leader>sd', require('telescope.builtin').lsp_document_symbols, '[S]earch [D]ocument symbols')
        map('<leader>sS', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[S]earch workspace [S]ymbols')
        map('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- ドキュメントハイライト
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = 'lsp-highlight', buffer = event2.buf })
            end,
          })
        end

        -- Inlay Hints トグル（UI）
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>uh', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
          end, '[U]I: Toggle inlay [H]ints')
        end
      end,
    })

    -- Capabilities 設定（cmp の補完機能を全サーバーに通知）
    -- vim.lsp.config('*') は全サーバー共通のベース設定
    -- サーバー個別設定は after/lsp/<server_name>.lua に配置（:h lsp-config）
    vim.lsp.config('*', {
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
    })

    -- mason-lspconfig v2: インストール済みサーバーを vim.lsp.enable() で自動有効化する
    -- （v1 の handlers オプションは廃止されているため使用しない）
    require('mason-lspconfig').setup({
      ensure_installed = {
        'lua_ls',
        'jsonls',
        'ts_ls',
        'pyright',
        'clangd',
      },
    })

    -- ツール自動インストール
    -- clang-format, black等のPython依存ツールは apt/pipx で手動インストール
    require('mason-tool-installer').setup({
      ensure_installed = {
        'lua-language-server',
        'stylua',
        'json-lsp',
        'prettier',
        'eslint_d',
        'typescript-language-server',
        'js-debug-adapter',
        'codelldb',
        'cspell',
        'pyright',
      },
    })
  end,
}
