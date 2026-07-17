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
        theme = {
          activeBorderColor = [ "#c4b28a" "bold" ];
          inactiveBorderColor = [ "#393836" ];
          searchingActiveBorderColor = [ "#e6c384" "bold" ];
          optionsTextColor = [ "#7fb4ca" ];
          selectedLineBgColor = [ "#2d4f67" ];
          inactiveViewSelectedLineBgColor = [ "#363646" ];
          defaultFgColor = [ "#c5c9c5" ];
          unstagedChangesColor = [ "#e46876" ];
          cherryPickedCommitFgColor = [ "#c5c9c5" ];
          cherryPickedCommitBgColor = [ "#2d4f67" ];
          markedBaseCommitFgColor = [ "#c5c9c5" ];
          markedBaseCommitBgColor = [ "#43436c" ];
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
