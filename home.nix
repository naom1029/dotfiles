{ pkgs, ... }:

{
  home.username = "naom1029";
  home.homeDirectory = "/home/naom1029";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  imports = [
    ./nix/programs/bash.nix
    ./nix/programs/direnv.nix
    ./nix/programs/git.nix
    ./nix/programs/herdr.nix
    ./nix/programs/lazygit.nix
    ./nix/programs/neovim.nix
    ./nix/programs/tmux.nix
    ./nix/programs/tools.nix
    ./nix/programs/wezterm.nix
  ];
}
