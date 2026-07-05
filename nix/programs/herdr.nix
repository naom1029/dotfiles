{ pkgs, ... }:

{
  home.packages = [ pkgs.herdr ];

  # ref: https://wiki.adachin.me/archives/3355
  xdg.configFile."herdr/config.toml".source = ../../config/herdr/config.toml;

  # herdr公式スキル（本体と同一バージョンのソースから取得）
  home.file.".claude/skills/herdr/SKILL.md".source = "${pkgs.herdr.src}/SKILL.md";
}
