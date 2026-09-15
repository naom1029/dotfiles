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

  # LSP の workspace/didChangeWatchedFiles 用。
  # inotifywait が無いと Neovim は vim._watch.watchdirs にフォールバックし、
  # 監視登録のたびに vim.fs.dir でツリー全体を同期走査してディレクトリ1つに
  # つき uv.fs_event ハンドルを作る。node_modules を含む大きなリポジトリでは
  # 1回あたり1.2秒メインループが止まる（実測: 10,188ディレクトリ）。
  home.packages = [ pkgs.inotify-tools ];

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
