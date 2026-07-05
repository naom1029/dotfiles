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
          activeBorderColor = [ "#007acc" "bold" ];
          inactiveBorderColor = [ "#3c3c3c" ];
          searchingActiveBorderColor = [ "#3794ff" "bold" ];
          optionsTextColor = [ "#3794ff" ];
          selectedLineBgColor = [ "#04395e" ];
          inactiveViewSelectedLineBgColor = [ "#37373d" ];
          defaultFgColor = [ "#cccccc" ];
          unstagedChangesColor = [ "#cca700" ];
          cherryPickedCommitFgColor = [ "#cccccc" ];
          cherryPickedCommitBgColor = [ "#264f78" ];
          markedBaseCommitFgColor = [ "#cccccc" ];
          markedBaseCommitBgColor = [ "#5a5d5e" ];
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
