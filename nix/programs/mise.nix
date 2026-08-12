{ config, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/src/github.com/naom1029/dotfiles";
in
{
  programs.mise = {
    enable = true;
    enableBashIntegration = true;
    # globalConfig は使わない。使うと config.toml が /nix/store への読み取り専用
    # シンボリックリンクになり、`mise use -g` が書き込みに失敗する。
  };

  # グローバル設定を dotfiles の実ファイルへ直接シンボリンクする。
  # これで `mise use -g <tool>` の書き込みがそのまま git の変更として現れ、
  # ツール一覧を .nix に書かずに追跡できる。
  # 追跡したくない単発の CLI は conf.d 側に入れる（下記 99-local.toml）。
  #   mise use -p ~/.config/mise/conf.d/99-local.toml npm:<pkg>
  xdg.configFile."mise/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/mise/config.toml";
}
