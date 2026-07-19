-- markdown-preview.nvim
-- Markdownのリアルタイムプレビュー（ブラウザ）

return {
  "iamcco/markdown-preview.nvim",
  ft = { "markdown" },
  build = "cd app && yarn install",
  keys = {
    { "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", desc = "[C]ode: Markdown [P]review" },
  },
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  config = function()
    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_auto_close = 1
    vim.g.mkdp_refresh_slow = 0
    vim.g.mkdp_browser = ""  -- デフォルトブラウザ
    vim.g.mkdp_theme = "dark" -- ダークテーマ
    vim.g.mkdp_preview_options = {
        mermaid = { -- Mermaidオプション
            theme = "dark",
        },
    }
  end,
}
