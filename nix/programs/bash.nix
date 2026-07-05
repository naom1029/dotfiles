{ pkgs, ... }:

{
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

  programs.readline = {
    enable = true;
    variables = {
      editing-mode = "vi";
      show-mode-in-prompt = true;
      vi-ins-mode-string = "\\1\\e[6 q\\2(ins)";
      vi-cmd-mode-string = "\\1\\e[2 q\\2(cmd)";
    };
    extraConfig = ''
      # vi insert mode でも Ctrl+A/Ctrl+E で行頭/行末移動
      set keymap vi-insert
      "\C-a": beginning-of-line
      "\C-e": end-of-line
      "\C-k": kill-line
      "\C-u": unix-line-discard
      "\C-w": backward-kill-word
      set keymap vi-command
      "\C-a": beginning-of-line
      "\C-e": end-of-line
    '';
  };
}
