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
        -- キー体系は Neovim 0.11+ の組み込みデフォルト（:h lsp-defaults）に従い、
        -- 一覧を表示する系はquickfixの代わりにTelescopeで上書きする。
        -- grn（リネーム）/ gra（コードアクション）/ K / <C-s> は組み込みのまま
        local builtin = require('telescope.builtin')
        map('grd', builtin.lsp_definitions, '定義へジャンプ')
        map('grD', vim.lsp.buf.declaration, '宣言へジャンプ')
        map('grr', builtin.lsp_references, '参照一覧')
        map('gri', builtin.lsp_implementations, '実装へジャンプ')
        map('grt', builtin.lsp_type_definitions, '型定義へジャンプ')
        map('gO', builtin.lsp_document_symbols, 'ドキュメントシンボル')
        map('<leader>sd', builtin.lsp_document_symbols, '[S]earch [D]ocument symbols')
        map('<leader>sS', builtin.lsp_dynamic_workspace_symbols, '[S]earch workspace [S]ymbols')

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
        end

        -- Inlay Hints トグル（UI）
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>uh', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
          end, '[U]I: Toggle inlay [H]ints')
        end
      end,
    })

    -- LSPデタッチ時にドキュメントハイライトの後始末をする
    -- 注意: LspAttachコールバックの中で登録すると、augroupのclearにより
    -- 先にアタッチしたバッファのハンドラが消えるバグになるため、ここで1回だけ登録する
    vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
      callback = function(event)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds({ group = 'lsp-highlight', buf = event.buf })
      end,
    })

    -- Capabilities 設定（cmp の補完機能を全サーバーに通知）
    -- vim.lsp.config('*') は全サーバー共通のベース設定
    -- サーバー個別設定は after/lsp/<server_name>.lua に配置（:h lsp-config）
    vim.lsp.config('*', {
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
    })

    -- 有効化するLSPサーバー（lspconfig名）
    -- mason-lspconfig v2 の automatic_enable はMasonでインストール済みの
    -- サーバーを無差別に有効化する（pylsp/pyright/ruffの3重アタッチ等の原因）ため
    -- 無効にし、kickstart.nvim方式で意図したサーバーだけを明示的に有効化する。
    -- ※ AstroNvim流に自動有効化を残して除外だけ指定する
    --    automatic_enable = { exclude = { ... } } という選択肢もある
    local servers = {
      'bashls',
      'clangd',
      'cssls',
      'cssmodules_ls',
      'docker_compose_language_service',
      'dockerls',
      'dotls',
      'html',
      'jsonls',
      'lua_ls',
      'markdown_oxide',
      'marksman',
      'nginx_language_server',
      'pyright',
      'ruff',
      'rust_analyzer',
      'svelte',
      'tailwindcss',
      'ts_ls',
      'yamlls',
    }

    require('mason-lspconfig').setup({
      ensure_installed = servers,
      automatic_enable = false,
    })
    vim.lsp.enable(servers)

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
