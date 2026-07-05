{ pkgs, lib, config, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/src/github.com/naom1029/dotfiles";
  nvimDotfilesDir = "${dotfilesDir}/config/nvim";
  nvimConfigDir = "${config.xdg.configHome}/nvim";
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withRuby = false;
    withPython3 = false;
  };

  # home-manager の xdg.configFile ではなく dotfiles への直接シンボリンクにする
  # lazy-lock.json 等を lazy.nvim が書き換えられるようにするため
  xdg.configFile."nvim/init.lua".enable = lib.mkForce false;

  home.activation.linkNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -d "${nvimConfigDir}" ] && [ ! -L "${nvimConfigDir}" ]; then
      rm -rf "${nvimConfigDir}"
    fi
    ln -sfn "${nvimDotfilesDir}" "${nvimConfigDir}"
  '';
}
