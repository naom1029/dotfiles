{ config, pkgs, lib, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/src/github.com/naom1029/dotfiles";
in
{
  home.packages = [ pkgs.herdr ];

  # ref: https://wiki.adachin.me/archives/3355
  # source で /nix/store に置くと読み取り専用になり、herdr 自身が UI から
  # 書き戻す設定（agent_panel_sort など）が EACCES で落ちる。dotfiles の
  # 実ファイルへ直接シンボリンクして、UI での変更を git の差分として拾う。
  xdg.configFile."herdr/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/herdr/config.toml";

  # エージェント連携フックを導入する。これが無いと resume_agents_on_restore が
  # セッション参照を受け取れず、復元時に素のシェルへ戻ってしまう。
  # フック本体は herdr 自身が版管理して上書きするため、home.file で固定せず
  # 冪等な install コマンドに任せる。
  home.activation.herdrIntegrations = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for agent in claude codex copilot; do
      run ${pkgs.herdr}/bin/herdr integration install "$agent" || true
    done
  '';
}
