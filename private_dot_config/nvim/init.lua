-- =====================================================================
-- ==================== Neovim Configuration ===========================
-- =====================================================================
--
--
-- 構造:
--   - lua/config/    : 基本設定（options, keymaps, autocmds, lazy）
--   - lua/plugins/   : プラグイン設定（各プラグインが個別ファイル）
--
-- =====================================================================

-- netrw を無効化（neo-tree/oil を使用）- プラグインより先に設定必須
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Leader key設定（プラグイン読み込み前に必須）
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd Font設定
vim.g.have_nerd_font = false

-- 基本設定の読み込み
require('config.options')   -- Vim options
require('config.keymaps')   -- キーマップ
require('config.autocmds')  -- Autocommands
require('config.lazy')      -- lazy.nvim & プラグイン

-- v0.11 のデフォルト LSP グローバルキーマップを削除（Telescope を使用するため）
local function unmap(mode, lhs)
  pcall(vim.keymap.del, mode, lhs)
end

local function clear_lsp_global_keys()
  local normal = { 'gra', 'gri', 'grn', 'grr', 'grt', 'gO' }
  for _, k in ipairs(normal) do
    unmap('n', k)
  end
  unmap('x', 'gra')
  -- 必要なら <C-s> も削除
  -- unmap('i', '<C-s>')
end

clear_lsp_global_keys()

-- vim: ts=2 sts=2 sw=2 et
