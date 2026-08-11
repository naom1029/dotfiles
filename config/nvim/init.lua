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
require('config.memo')      -- メモ管理（自前実装）
require('config.lazy')      -- lazy.nvim & プラグイン

-- vim: ts=2 sts=2 sw=2 et
