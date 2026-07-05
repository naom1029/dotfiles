{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # search & file utilities
    ripgrep
    fd
    bat
    eza
    jq
    tree
    dust
    trash-cli
    vivid
    zoxide

    # python
    uv
    pipx

    # development
    ghq
    gh-dash
    online-judge-tools
    claude-code

    # monitoring
    btop
    lazydocker
  ];

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  xdg.configFile."gh-dash/config.yml".source = ../../config/gh-dash/config.yml;
  xdg.configFile."ccstatusline/settings.json".source = ../../config/ccstatusline/settings.json;
}
