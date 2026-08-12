{ pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";
  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.home-manager.enable = true;

  imports = [
    ./nix/programs/xdg.nix
    ./nix/programs/agent-skills.nix
    ./nix/programs/bash.nix
    ./nix/programs/claude-code.nix
    ./nix/programs/git.nix
    ./nix/programs/git-hooks.nix
    ./nix/programs/herdr.nix
    ./nix/programs/hunk.nix
    ./nix/programs/jj.nix
    ./nix/programs/lazygit.nix
    ./nix/programs/mise.nix
    ./nix/programs/neovim.nix
    ./nix/programs/tmux.nix
    ./nix/programs/tools.nix
    ./nix/programs/wezterm.nix
  ];
}
