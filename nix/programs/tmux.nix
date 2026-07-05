{ pkgs, ... }:

{
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

  xdg.configFile."tmux/cheatsheet.md".source = ../../config/tmux/cheatsheet.md;
}
