{ pkgs, lib, config, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/src/github.com/naom1029/dotfiles";
  claudeDotfilesDir = "${dotfilesDir}/.claude";

  # Settings template — activate when ready to manage settings.json via Nix.
  # To enable: uncomment the activation block at the bottom.
  _settingsTemplate = {
    "$schema" = "https://json.schemastore.org/claude-code-settings.json";
    model = "claude-opus-4-6[1M]";
    theme = "dark";
    tui = "fullscreen";
    skipWorkflowUsageWarning = true;
    env = {
      CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
    };
    enabledPlugins = {
      "code-review@claude-plugins-official" = true;
      "code-simplifier@claude-plugins-official" = true;
      "context7@claude-plugins-official" = true;
      "feature-dev@claude-plugins-official" = true;
      "pr-review-toolkit@claude-plugins-official" = true;
      "rust-analyzer-lsp@claude-plugins-official" = true;
      "typescript-lsp@claude-plugins-official" = true;
      "serena@claude-plugins-official" = true;
      "security-guidance@claude-plugins-official" = true;
      "example-skills@anthropic-agent-skills" = true;
      "frontend-design@claude-plugins-official" = true;
      "clangd-lsp@claude-plugins-official" = true;
      "lua-lsp@claude-plugins-official" = true;
    };
    statusLine = {
      type = "command";
      command = "npx -y ccstatusline@latest";
      refreshInterval = 10;
      padding = 0;
    };
    hooks = {
      SessionStart = [
        {
          matcher = "*";
          hooks = [
            {
              type = "command";
              command = "bash '${config.home.homeDirectory}/.claude/hooks/herdr-agent-state.sh' session";
              timeout = 10;
            }
          ];
        }
      ];
    };
  };
in
{
  # TODO: Uncomment when ready to manage CLAUDE.md via Nix
  # home.file.".claude/CLAUDE.md".source =
  #   config.lib.file.mkOutOfStoreSymlink "${claudeDotfilesDir}/CLAUDE.md";

  # TODO: Uncomment when ready to manage settings.json via Nix
  # This will overwrite the existing settings.json.
  #
  # home.activation.writeClaudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #   mkdir -p "${config.home.homeDirectory}/.claude"
  #   cp --no-preserve=mode,ownership \
  #     ${(pkgs.formats.json {}).generate "claude-settings.json" _settingsTemplate} \
  #     "${config.home.homeDirectory}/.claude/settings.json"
  #   chmod 644 "${config.home.homeDirectory}/.claude/settings.json"
  # '';
}
