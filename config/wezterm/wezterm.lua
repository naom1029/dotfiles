local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- 基本設定
config.automatically_reload_config = true
config.use_ime = true
config.font_size = 10.0
-- VSCode Dark Modernに統一（Neovim側はarctic.nvimで同じ配色）。
-- Dark ModernはVSCode側でターミナルのANSI配色を独自定義していないため、
-- その継承元であるDark+のポート(Gogh)をベースに、エディタ本体の背景/文字色/選択色だけ
-- Dark Modernの実値（arctic.nvimの移植元と同じ #1F1F1F / #CCCCCC / #264F78）で上書きする。
config.color_scheme = "Vs Code Dark+ (Gogh)"

-- kitty keyboard protocol は無効のまま
-- （herdr マルチプレクサが非対応で、有効にすると ESC 等が CSI u 形式になり壊れるため。
--  参考: https://qiita.com/getty104/items/5e2239edf03fa4d1b4c8）

-- フォント設定
-- 記号は同梱の Symbols Nerd Font ではなく font_dirs の新しい版に解決させる。
-- 同梱版は nf-dev-yaml (U+E8EB) 等を持たず、Windows へフォントをインストールしても
-- 同梱版が優先されるため、font_dirs (最優先) に置く必要がある。
-- 配置は nix/programs/wezterm.nix の activation が行う。
config.font_dirs = { "fonts" }
-- CJK フォントもフォールバックに明示する。省略すると CJK が同じシェイプ単位に
-- 混ざったとき DirectWrite のシステムフォールバックまで降りてしまい、font_dirs の
-- フォントは Windows に未登録なので「No fonts contain glyphs」警告が出る。
-- 明示すると解決が WezTerm 内で完結し、グリフの解決結果は変わらないまま警告が消える。
config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
	"Symbols Nerd Font Mono",
	"Yu Gothic UI",
})

-- ============================================
-- ウィンドウ・UI 設定
-- ============================================
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = false -- モード表示のため常にタブバーを表示
config.tab_bar_at_bottom = false -- タブバーを上に配置

-- 上下の余白を削って行数を稼ぐ（既定は上下 0.5cell）。
-- 左右は既定値のまま明示する（部分指定時の既定維持が未文書のため）。
config.window_padding = {
	left = "1cell",
	right = "1cell",
	top = 0,
	bottom = 0,
}

config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}

config.show_new_tab_button_in_tab_bar = false

config.colors = {
	background = "#1F1F1F",
	foreground = "#CCCCCC",
	cursor_bg = "#CCCCCC",
	cursor_border = "#CCCCCC",
	cursor_fg = "#1F1F1F",
	selection_bg = "#264F78",
	tab_bar = {
		inactive_tab_edge = "none",
	},
}

-- タブのタイトル表示設定
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#5c6d74"
	local foreground = "#FFFFFF"

	if tab.is_active then
		background = "#ae8b2d"
		foreground = "#FFFFFF"
	end

	local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

	return {
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
	}
end)

-- ============================================
-- デフォルトドメイン（WSL）
-- ============================================
-- WSL ドメインを使うことで、分割時に同じディレクトリで開く
-- ディストロ名は wsl -l -v で確認可能
config.default_domain = "WSL:Ubuntu"

-- ============================================
-- Launch Menu：起動時の選択肢
-- ============================================
config.launch_menu = {
	-- WSL 側
	{
		label = "WSL: Ubuntu",
		domain = { DomainName = "WSL:Ubuntu" },
	},
	{
		-- herdr は ~/.nix-profile/bin にあるためログインシェル経由で PATH を通す
		label = "WSL: Ubuntu (herdr)",
		args = { "bash", "-lc", "herdr" },
		domain = { DomainName = "WSL:Ubuntu" },
	},
	-- Windows 側
	{
		label = "Windows PowerShell",
		args = { "powershell.exe", "-NoLogo" },
		domain = { DomainName = "local" },
	},
	{
		label = "PowerShell 7",
		args = { "pwsh.exe", "-NoLogo" },
		domain = { DomainName = "local" },
	},
	{
		label = "Command Prompt",
		args = { "cmd.exe" },
		domain = { DomainName = "local" },
	},
}

-- ============================================
-- キーバインド設定を読み込み
-- ============================================
local keybinds = require("keybinds")

-- Zen Mode 設定を読み込み
require("zen-mode")

-- リーダーキー設定（tmux/screen と同じ Ctrl+A）
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = keybinds.keys
config.key_tables = keybinds.key_tables

-- ランチャーメニューを開くキーバインドを追加
table.insert(config.keys, {
	key = "P",
	mods = "CTRL|SHIFT",
	action = wezterm.action.ShowLauncher,
})

-- ============================================
-- Claude Code からのベル通知をOS通知に変換
-- ============================================
local function is_claude(pane)
	local process = pane:get_foreground_process_info()
	if not process or not process.argv then
		return false
	end
	for _, arg in ipairs(process.argv) do
		if arg:find("claude") then
			return true
		end
	end
	return false
end

local function get_tab_id(window, pane)
	local mux_window = window:mux_window()
	for i, tab_info in ipairs(mux_window:tabs_with_info()) do
		for _, p in ipairs(tab_info.tab:panes()) do
			if p:pane_id() == pane:pane_id() then
				return i
			end
		end
	end
end

wezterm.on("bell", function(window, pane)
	if is_claude(pane) then
		local tab_id = get_tab_id(window, pane)
		local msg = "Task completed"
		if tab_id then
			msg = msg .. " (Tab " .. tab_id .. ")"
		end
		window:toast_notification("Claude Code", msg, nil, 4000)
	end
end)

-- ============================================
-- モード表示（左下、Neovim風）
-- ============================================
wezterm.on("update-right-status", function(window, pane)
	local mode_name = window:active_key_table()

	if mode_name then
		-- Neovim風のモード表記
		local mode_labels = {
			resize_pane = "RESIZE",
			activate_pane = "NAVIGATE",
			copy_mode = "VISUAL",
		}
		local mode_text = mode_labels[mode_name] or mode_name:upper()

		-- 左側に表示（Neovim風）
		window:set_left_status(wezterm.format({
			{ Background = { Color = "#ae8b2d" } },
			{ Foreground = { Color = "#000000" } },
			{ Text = " " .. mode_text .. " " },
		}))
	else
		window:set_left_status("")
	end

	window:set_right_status("")
end)

return config
