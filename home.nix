{ pkgs, ... }:

{
  home.username = "naom1029";
  home.homeDirectory = "/home/naom1029";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ghq
    lazydocker
    herdr
  ];

  # Git
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
      merge.conflictstyle = "zdiff3";
      rerere.enabled = true;
      init.defaultBranch = "main";
      fetch.prune = true;
      include.path = "~/.config/delta/themes.gitconfig";
    };
  };

  # Delta (git pager)
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

  # GitHub CLI
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  # fzf
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  # tmux
  programs.tmux = {
    enable = true;
    prefix = "C-g";
    baseIndex = 1;
    mouse = true;
    escapeTime = 0;
    historyLimit = 100000;
    keyMode = "vi";
    terminal = "tmux-256color";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      continuum
      yank
    ];
    extraConfig = ''
      # terminal overrides
      set -ag terminal-overrides ",xterm-256color:RGB,*256col*:RGB"

      # clipboard (OSC 52)
      set -g set-clipboard on
      set -as terminal-features ',xterm*:clipboard'

      # focus events (Neovim)
      set -g focus-events on

      # pane base index
      setw -g pane-base-index 1
      set -g renumber-windows on

      # reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded"

      # cheatsheet popup
      bind ? display-popup -E -w 80% -h 80% "less -R ~/.config/tmux/cheatsheet.md"
      bind / list-keys

      # window navigation (no prefix)
      bind -n M-] next-window
      bind -n M-[ previous-window
      bind -n M-w confirm-before -p "kill-window #W? (y/n)" kill-window

      # pane split (no prefix)
      bind -n M-- split-window -v -c "#{pane_current_path}"
      bind -n M-| split-window -h -c "#{pane_current_path}"

      # pane navigation
      bind -n M-h select-pane -L
      bind -n M-l select-pane -R
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U

      # pane close / zoom
      bind -n M-x confirm-before -p "kill-pane? (y/n)" kill-pane
      bind -n M-\\ resize-pane -Z

      # copy mode vi bindings
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi C-v send -X rectangle-toggle
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel

      # status bar
      set -g status-position bottom
      set -g status-interval 1
      set -g status-style "bg=colour233,fg=colour245"
      set -g status-left "#[fg=colour233,bg=colour114,bold]  #S #[fg=colour114,bg=colour233]"
      set -g status-left-length 20
      set -g status-right "#[fg=colour237,bg=colour233]#[fg=colour245,bg=colour237] %H:%M "
      set -g status-right-length 20
      set -g window-status-format "#[fg=colour233,bg=colour237]#[fg=colour244,bg=colour237] #I #W #[fg=colour237,bg=colour233]"
      set -g window-status-current-format "#[fg=colour233,bg=colour114]#[fg=colour233,bg=colour114,bold] #I #W #[fg=colour114,bg=colour233]"
      set -g window-status-separator ""
      set -g pane-border-style "fg=colour237"
      set -g pane-active-border-style "fg=colour114"

      # disable auto rename
      set -g allow-rename off

      # resurrect settings
      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-strategy-nvim 'session'
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '15'
    '';
  };

  # lazygit
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

  # Neovim (lua config is managed separately for now)
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withRuby = false;
    withPython3 = false;
  };

  # Bash
  programs.bash = {
    enable = true;
    historyControl = [ "ignoreboth" ];
    historySize = 1000;
    historyFileSize = 2000;
    shellOptions = [
      "histappend"
      "checkwinsize"
    ];
    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      g = "ghqcd";
      wt = "wtcd";
      memo = "nvim +MemoToday";
    };
    initExtra = ''
      # Git prompt
      for f in /usr/lib/git-core/git-sh-prompt /usr/share/git/git-prompt.sh /etc/bash_completion.d/git-prompt; do
          [ -f "$f" ] && . "$f" && break
      done

      # Prompt with git branch
      PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;33m\]$(__git_ps1 " (%s)")\[\033[00m\]\$ '

      # Volta
      if [ -d "$HOME/.volta" ]; then
          export VOLTA_HOME="$HOME/.volta"
          export PATH="$VOLTA_HOME/bin:$PATH"
      fi

      # Cargo
      [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

      # Go
      [ -d "$HOME/go/bin" ] && export PATH="$HOME/go/bin:$PATH"

      # ghq
      export GHQ_ROOT="$HOME/src"

      # ghq + fzf
      function ghqcd() {
        local selected
        selected=$(
          { ghq list --full-path 2>/dev/null; find ~/workspace -maxdepth 1 -mindepth 1 -type d 2>/dev/null; } \
          | sort -u \
          | fzf --preview 'git -C {} log --oneline -5 2>/dev/null || ls {}'
        ) && cd "$selected"
      }

      # git worktree + fzf
      function wtcd() {
        local wt
        wt=$(git worktree list | fzf | awk '{print $1}') && cd "$wt"
      }

      # WezTerm OSC 7
      __wezterm_osc7() {
          printf '\e]7;file://%s%s\e\\' "$(hostname)" "$(pwd)"
      }
      [[ "$PROMPT_COMMAND" != *__wezterm_osc7* ]] && PROMPT_COMMAND="__wezterm_osc7;''${PROMPT_COMMAND}"
    '';
  };

  # readline (inputrc)
  programs.readline = {
    enable = true;
    variables = {
      editing-mode = "vi";
      show-mode-in-prompt = true;
      vi-ins-mode-string = "\\1\\e[6 q\\2(ins)";
      vi-cmd-mode-string = "\\1\\e[2 q\\2(cmd)";
    };
  };

  # herdr config (ref: https://wiki.adachin.me/archives/3355)
  xdg.configFile."herdr/config.toml".text = ''
    onboarding = false

    [keys]
    prefix = "ctrl+t"
    detach = "prefix+d"
    new_tab = "prefix+c"
    close_tab = "prefix+&"
    rename_tab = "prefix+,"
    previous_tab = "prefix+p"
    switch_tab = "prefix+1..9"
    split_vertical = "prefix+%"
    split_horizontal = "prefix+\\"
    last_pane = "prefix+;"
    close_pane = "prefix+x"
    copy_mode = "prefix+["
    reload_config = "prefix+r"
    resize_mode = "prefix+shift+r"

    [theme]
    name = "terminal"
    auto_switch = true
    dark_name = "dracula"
    light_name = "catppuccin-latte"

    [session]
    resume_agents_on_restore = true

    [ui]
    show_agent_labels_on_pane_borders = true

    [ui.toast]
    delivery = "system"

    [ui.sound]
    enabled = false
  '';

  # gh-dash config
  xdg.configFile."gh-dash/config.yml".text = builtins.readFile ./config/gh-dash/config.yml;
}
