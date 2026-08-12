{ pkgs, lib, ... }:

{
  home.packages = [ pkgs.herdr ];

  # ref: https://wiki.adachin.me/archives/3355
  xdg.configFile."herdr/config.toml".source = ../../config/herdr/config.toml;

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
