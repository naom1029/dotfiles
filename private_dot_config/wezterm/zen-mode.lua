local wezterm = require("wezterm")

-- Zen Mode のトグル機能
wezterm.on("toggle-zen-mode", function(window, pane)
	local overrides = window:get_config_overrides() or {}

	-- 現在zen-modeが有効かチェック
	if overrides.enable_tab_bar == false then
		-- zen-mode解除
		overrides.font_size = nil
		overrides.enable_tab_bar = true
	else
		-- zen-mode有効化（フォントサイズ16）
		overrides.font_size = 10.5
		overrides.enable_tab_bar = false
	end

	window:set_config_overrides(overrides)
end)

-- シェルからのuser-var制御も残す
wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)
