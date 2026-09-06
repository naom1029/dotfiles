{ config, lib, pkgs, ... }:

let
  statusLine =
    ''["model-with-reasoning", "git-branch", "branch-changes", "current-dir", "context-used", "five-hour-limit", "weekly-limit"]'';
in
{
  home.file.".codex/network_enabled.config.toml".text = ''
    sandbox_mode = "workspace-write"
    approval_policy = "on-request"

    [sandbox_workspace_write]
    network_access = true
  '';

  # config.toml は Codex 自身も trust 設定などを書き換えるため、ファイル全体を
  # Nix 管理下には置かず、自分で管理したいトップレベル設定とステータスラインだけを同期する。
  home.activation.codexConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    config_file="${config.home.homeDirectory}/.codex/config.toml"
    mkdir -p "$(dirname "$config_file")"
    source_file="$config_file"
    [ -f "$source_file" ] || source_file=/dev/null
    tmp=$(mktemp)

    ${pkgs.gawk}/bin/awk -v status_line='${statusLine}' '
      function write_root_settings() {
        print "web_search = \"live\""
        print "hide_agent_reasoning = true"
        print ""
        wrote_root_settings = 1
      }

      function write_status_line() {
        print "status_line = " status_line
        print "status_line_use_colors = true"
        wrote_status_line = 1
      }

      !wrote_root_settings && /^\[/ {
        write_root_settings()
      }

      # 旧設定の [tool] セクションと、その中の誤記されたキーを除去する。
      /^\[tool\]$/ {
        in_legacy_tool = 1
        next
      }

      in_legacy_tool && /^(web_search|hide_agent_resoning)[[:space:]]*=/ { next }

      in_legacy_tool && /^\[/ {
        in_legacy_tool = 0
      }

      /^\[profiles\.network_enabled(\..*)?\]$/ {
        in_legacy_profile = 1
        next
      }

      in_legacy_profile && !/^\[/ { next }

      in_legacy_profile && /^\[/ {
        in_legacy_profile = 0
      }

      !wrote_root_settings && /^(web_search|hide_agent_reasoning)[[:space:]]*=/ { next }

      /^\[tui\]$/ {
        if (in_tui && !wrote_status_line) write_status_line()
        in_tui = 1
        found_tui = 1
        wrote_status_line = 0
        print
        next
      }

      /^\[/ {
        if (in_tui && !wrote_status_line) write_status_line()
        in_tui = 0
      }

      in_tui && /^status_line(_use_colors)?[[:space:]]*=/ { next }

      { print }

      END {
        if (!wrote_root_settings) write_root_settings()
        if (in_tui && !wrote_status_line) {
          write_status_line()
        } else if (!found_tui) {
          print ""
          print "[tui]"
          write_status_line()
        }
      }
    ' "$source_file" > "$tmp"

    run mv "$tmp" "$config_file"
  '';
}
