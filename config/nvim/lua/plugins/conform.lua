-- conform.nvim
-- コードフォーマッター

local function use_if_executable(formatter)
  return function()
    if vim.fn.executable(formatter) == 1 then
      return { formatter }
    end
    return {}
  end
end

return {
  'stevearc/conform.nvim',
  event = 'VeryLazy',
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[C]ode [F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = {
      timeout_ms = 500,
      lsp_format = 'fallback',
    },
    formatters_by_ft = {
      -- Lua
      lua = use_if_executable('stylua'),
      -- C/C++
      c = use_if_executable('clang-format'),
      cpp = use_if_executable('clang-format'),
      -- Rust
      rust = use_if_executable('rustfmt'),
      -- Go
      go = use_if_executable('gofmt'),
      gomod = use_if_executable('gofmt'),
      -- JavaScript/TypeScript
      javascript = use_if_executable('prettier'),
      javascriptreact = use_if_executable('prettier'),
      typescript = use_if_executable('prettier'),
      typescriptreact = use_if_executable('prettier'),
      vue = use_if_executable('prettier'),
      svelte = use_if_executable('prettier'),
      -- JSON/YAML/TOML
      json = use_if_executable('prettier'),
      jsonc = use_if_executable('prettier'),
      yaml = use_if_executable('prettier'),
      toml = use_if_executable('taplo'),
      -- Python
      python = use_if_executable('black'),
      -- Ruby
      ruby = use_if_executable('rubocop'),
      -- PHP
      php = use_if_executable('pint'),
      -- Shell
      sh = use_if_executable('shfmt'),
      bash = use_if_executable('shfmt'),
      zsh = use_if_executable('shfmt'),
      -- Web
      html = use_if_executable('prettier'),
      css = use_if_executable('prettier'),
      scss = use_if_executable('prettier'),
      less = use_if_executable('prettier'),
      graphql = use_if_executable('prettier'),
      -- Docs
      markdown = use_if_executable('prettier'),
      -- SQL
      sql = use_if_executable('sql-formatter'),
      -- Terraform
      terraform = use_if_executable('terraform_fmt'),
      tf = use_if_executable('terraform_fmt'),
      -- Zig
      zig = use_if_executable('zigfmt'),
    },
  },
}
