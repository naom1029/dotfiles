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

  xdg.configFile."gh-dash/config.yml".text = builtins.readFile ../../config/gh-dash/config.yml;
  xdg.configFile."ccstatusline/settings.json".text = builtins.readFile ../../config/ccstatusline/settings.json;
}
