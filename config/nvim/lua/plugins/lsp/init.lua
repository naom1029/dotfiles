-- LSP 設定（Neovim 0.11 対応）

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
    require('mason-lspconfig').setup()

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
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>sd', require('telescope.builtin').lsp_document_symbols, '[S]earch [D]ocument symbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- ドキュメントハイライト
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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

        -- Inlay Hints トグル
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>ti', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
          end, '[T]oggle [I]nlay hints')
        end
      end,
    })

    -- Capabilities 設定
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
    capabilities.offsetEncoding = { 'utf-8' }

    -- サーバー自動セットアップ
    -- 個別設定は lua/plugins/lsp/<server_name>.lua に配置
    require('mason-lspconfig').setup({
      ensure_installed = {
        'lua_ls',
        'jsonls',
        'ts_ls',
        'pyright',
      },
      handlers = {
        -- デフォルトハンドラー
        function(server_name)
          local server_config = { capabilities = capabilities }

          -- 個別設定ファイルを読み込み
          local config_path = vim.fn.stdpath('config') .. '/lua/plugins/lsp/' .. server_name .. '.lua'
          if vim.fn.filereadable(config_path) == 1 then
            local ok, custom_config = pcall(dofile, config_path)
            if ok and type(custom_config) == 'table' then
              server_config = vim.tbl_deep_extend('force', server_config, custom_config)
            end
          end

          require('lspconfig')[server_name].setup(server_config)
        end,
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
        'cspell',
        'pyright',
      },
    })
  end,
}
