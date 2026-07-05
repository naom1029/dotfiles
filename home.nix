{ pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  imports = [
    ./nix/programs/bash.nix
    ./nix/programs/claude-code.nix
    ./nix/programs/direnv.nix
    ./nix/programs/git.nix
    ./nix/programs/git-hooks.nix
    ./nix/programs/herdr.nix
    ./nix/programs/jj.nix
    ./nix/programs/lazygit.nix
    ./nix/programs/neovim.nix
    ./nix/programs/tmux.nix
    ./nix/programs/tools.nix
    ./nix/programs/wezterm.nix
  ];
}
