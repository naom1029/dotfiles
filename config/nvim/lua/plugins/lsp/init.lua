-- LSP 設定（Neovim 0.12 対応）

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
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
          vim.keymap.set(mode, keys, func, { buf = event.buf, desc = 'LSP: ' .. desc })
        end

        -- キーマップ
        -- Neovim 0.11+ の組み込みデフォルトをそのまま使う（:h lsp-defaults）:
        --   grn - リネーム / gra - コードアクション / grr - 参照一覧
        --   gri - 実装へジャンプ / grt - 型定義へジャンプ / gO - ドキュメントシンボル
        --   K - ホバー / <C-s> (insert) - シグネチャヘルプ
        -- ここではネイティブに存在しないものだけ定義する
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('<leader>sd', require('telescope.builtin').lsp_document_symbols, '[S]earch [D]ocument symbols')
        map('<leader>sS', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[S]earch workspace [S]ymbols')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- ドキュメントハイライト
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buf = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buf = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = 'lsp-highlight', buf = event2.buf })
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

    -- ツール自動インストール（LSP以外のフォーマッター・リンター・デバッガー）
    -- LSPサーバーは mason-lspconfig の ensure_installed で宣言する（重複させない）
    -- clang-format, black等のPython依存ツールは apt/pipx で手動インストール
    require('mason-tool-installer').setup({
      ensure_installed = {
        'stylua',
        'prettier',
        'eslint_d',
        'js-debug-adapter',
        'codelldb',
        'cspell',
      },
    })
  end,
}
