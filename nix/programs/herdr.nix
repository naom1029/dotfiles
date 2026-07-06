{ pkgs, ... }:

{
  home.packages = [ pkgs.herdr ];

  # ref: https://wiki.adachin.me/archives/3355
  xdg.configFile."herdr/config.toml".source = ../../config/herdr/config.toml;
}
