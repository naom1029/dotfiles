-- markdown-preview.nvim
-- Markdownのリアルタイムプレビュー（ブラウザ）

return {
  "iamcco/markdown-preview.nvim",
  ft = { "markdown" },
  build = "cd app && yarn install",
  -- plugin/mkdp.vim は読み込み時に s:init() を実行し、その時点の g:mkdp_* を見て
  -- autocmd を登録する。config では手遅れになるため init で設定すること。
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function(event)
        vim.keymap.set("n", "<leader>vp", "<cmd>MarkdownPreviewToggle<cr>", {
          buf = event.buf,
          desc = "[V]iew: Markdown [P]review (browser)",
        })
      end,
    })
  end,
  config = function()
    vim.g.mkdp_auto_start = 0
    -- combine_preview 有効時は 0 が前提（プラグイン README の指定）
    vim.g.mkdp_auto_close = 0
    vim.g.mkdp_refresh_slow = 0
    -- 既存のプレビュータブを再利用し、Markdownバッファの移動に追従させる
    vim.g.mkdp_combine_preview = 1
    vim.g.mkdp_combine_preview_auto_refresh = 1
    vim.g.mkdp_echo_preview_url = 1
    vim.g.mkdp_browser = "" -- デフォルトブラウザ
    vim.g.mkdp_theme = "light" -- ライトテーマ（未設定にするとOSの設定に追従する）
    -- mkdp_preview_options は意図的に未設定。
    -- Mermaid のテーマは mkdp_theme に自動追従する（app/pages/index.jsx:289
    -- `mermaid.initialize({ theme: this.state.theme, ...options.maid })`）。
    -- なおオプションのキーは "mermaid" ではなく "maid" のため、明示指定する場合は注意。
  end,
}
