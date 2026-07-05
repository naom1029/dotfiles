{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ghq
    lazydocker
  ];

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  xdg.configFile."gh-dash/config.yml".source = ../../config/gh-dash/config.yml;
  xdg.configFile."ccstatusline/settings.json".source = ../../config/ccstatusline/settings.json;
}
