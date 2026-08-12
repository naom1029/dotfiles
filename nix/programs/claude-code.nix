{ pkgs, lib, config, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/src/github.com/naom1029/dotfiles";
  claudeDotfilesDir = "${dotfilesDir}/.claude";

  # bashOptions は空にする。既定の errexit が付くと、スクリプト中の
  # `[ -n "$x" ] && y=z` が偽のときに終了コード 1 で死んでしまう。
  statuslineScript = pkgs.writeShellApplication {
    name = "claude-statusline";
    runtimeInputs = [
      pkgs.jq
      pkgs.git
      pkgs.coreutils
      pkgs.gnused
      pkgs.util-linux
    ];
    bashOptions = [ ];
    text = builtins.readFile ../../config/claude/statusline.sh;
  };
in
{
  # TODO: Uncomment when ready to manage CLAUDE.md via Nix
  # home.file.".claude/CLAUDE.md".source =
  #   config.lib.file.mkOutOfStoreSymlink "${claudeDotfilesDir}/CLAUDE.md";

  # settings.json は Claude Code 自身が実行時に書き換える（/model、/plugin 等）ため
  # ファイル全体を Nix 管理下に置けない。statusLine キーだけを jq でマージする。
  home.activation.claudeStatusLine = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings="${config.home.homeDirectory}/.claude/settings.json"
    if [ -f "$settings" ]; then
      tmp=$(mktemp)
      if ${pkgs.jq}/bin/jq \
        --arg cmd '${lib.getExe statuslineScript}' \
        '.statusLine = { type: "command", command: $cmd, refreshInterval: 10 }' \
        "$settings" > "$tmp"; then
        run mv "$tmp" "$settings"
      else
        rm -f "$tmp"
      fi
    fi
  '';
}
