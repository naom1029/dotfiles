{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    ignores = [
      "**/.claude/settings.local.json"
    ];
    settings = {
      user = {
        name = "naom1029";
        email = "56006010+naom1029@users.noreply.github.com";
      };
      core = {
        ignorecase = false;
        editor = "vim";
        quotepath = false;
      };
      push = {
        autoSetupRemote = true;
        useForceIfIncludes = true;
      };
      pull.rebase = true;
      rebase = {
        autoStash = true;
        autoSquash = true;
        updateRefs = true;
      };
      merge = {
        ff = false;
        conflictstyle = "zdiff3";
      };
      commit.verbose = true;
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        renames = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      init.defaultBranch = "main";
      fetch = {
        prune = true;
        all = true;
      };
      ghq.root = "~/src";
      branch.sort = "-committerdate";
      column.ui = "auto";
      help.autocorrect = "prompt";
      include.path = "~/.config/delta/themes.gitconfig";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      features = "zebra-dark";
      dark = true;
      side-by-side = true;
      line-numbers = false;
      file-decoration-style = "brightblue ul";
      hyperlinks = true;
      hyperlinks-file-link-format = "lazygit-edit://{path}:{line}";
      merge-conflict-begin-symbol = "";
      merge-conflict-end-symbol = "";
      merge-conflict-ours-diff-header-style = "omit";
      merge-conflict-theirs-diff-header-style = "omit";
      file-style = "brightblue bold";
      hunk-header-style = "file line-number syntax";
      navigate = true;
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
}
