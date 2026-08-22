{ pkgs, ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        border = "single";
        showRootItemInFileTree = false;
        showListFooter = false;
        showRandomTip = false;
        showNumstatInFilesView = true;
        commandLogSize = 4;
        nerdFontsVersion = "3";
        # VSCode Dark Modernの配色に統一（Neovim側のarctic.nvimと同じパレット）
        theme = {
          activeBorderColor = [ "#569CD6" "bold" ];
          inactiveBorderColor = [ "#454545" ];
          searchingActiveBorderColor = [ "#DCDCAA" "bold" ];
          optionsTextColor = [ "#9CDCFE" ];
          selectedLineBgColor = [ "#264F78" ];
          inactiveViewSelectedLineBgColor = [ "#3a3d41" ];
          defaultFgColor = [ "#cccccc" ];
          unstagedChangesColor = [ "#D16969" ];
          cherryPickedCommitFgColor = [ "#cccccc" ];
          cherryPickedCommitBgColor = [ "#264F78" ];
          markedBaseCommitFgColor = [ "#ffffff" ];
          markedBaseCommitBgColor = [ "#212d3a" ];
        };
      };
      git = {
        autoFetch = true;
        fetchAll = true;
        pagers = [
          {
            colorArg = "always";
            pager = "delta --paging=never";
          }
        ];
        log = {
          showGraph = "always";
          showWholeGraph = false;
        };
        branchLogCmd = "git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium {{branchName}} --";
      };
    };
  };
}
