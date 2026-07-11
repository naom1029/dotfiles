{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # search & file utilities
    ripgrep
    fd
    jq
    jnv
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
    git-wt
    gh-dash
    online-judge-tools
    claude-code
    tree-sitter

    # monitoring
    btop
    lazydocker
  ];

  # fzf
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    defaultCommand = "rg --files --hidden --follow --glob '!.git/'";
    defaultOptions = [
      "--extended"
      "--cycle"
      "--select-1"
      "--height 40%"
      "--reverse"
      "--border"
    ];
    fileWidget.command = "rg --files --hidden --follow --glob '!.git/'";
    fileWidget.options = [
      "--preview 'bat --color=always --style=header,grid --line-range :100 {}'"
    ];
    historyWidget.options = [
      "--preview 'echo {}'"
      "--preview-window down:3:hidden:wrap"
      "--bind '?:toggle-preview'"
    ];
  };

  # bat
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
    };
  };

  # eza
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
  };

  # zoxide
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  xdg.configFile."gh-dash/config.yml".source = ../../config/gh-dash/config.yml;
  xdg.configFile."ccstatusline/settings.json".source = ../../config/ccstatusline/settings.json;
}
