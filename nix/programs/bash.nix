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
      ls = "eza";
      ll = "eza -hlF";
      la = "eza -hlA";
      lt = "eza --tree";
      lg = "eza -hlFg";
      l = "eza -F";
      g = "ghqcd";
      wt = "wtcd";
      memo = "nvim +MemoToday";
      rm = "trash-put";
      mkcd = "mkdir -p $1 && cd $1";
    };
    bashrcExtra = ''
      # Nix (bashrc先頭で読み込み、Nixパッケージをapt版より優先)
      [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ] && . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    '';
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

      # ghq + fzf (eza preview)
      function ghqcd() {
        local selected
        selected=$(
          ghq list --full-path 2>/dev/null \
          | fzf --preview 'eza --tree --level=2 --git-ignore --color=always --icons {} 2>/dev/null || ls {}'
        ) && cd "$selected"
      }

      # git-wt shell integration
      eval "$(git-wt --init bash 2>/dev/null)"

      # git worktree + fzf (select & cd)
      function wtcd() {
        local wt
        wt=$(git wt --json 2>/dev/null | jq -r '.[] | "\(.path) (\(.branch))\t\(.path)"' \
          | fzf --delimiter '\t' --with-nth 1 \
              --preview 'git -C {2} log --oneline -10 --color=always 2>/dev/null' \
          | cut -f2) && cd "$wt"
      }

      # git switch branch with fzf
      function gsw() {
        local branch
        branch=$(git branch --sort=-committerdate --format='%(refname:short)' | fzf --preview 'git log --oneline -10 --color=always {}') && git switch "$branch"
      }

      # mkcd
      function mkcd() {
        mkdir -p "$1" && cd "$1"
      }

      # WezTerm OSC 7
      __wezterm_osc7() {
          printf '\e]7;file://%s%s\e\\' "$(hostname)" "$(pwd)"
      }
      if [[ "$PROMPT_COMMAND" != *__wezterm_osc7* ]]; then
        PROMPT_COMMAND="__wezterm_osc7''${PROMPT_COMMAND:+;''${PROMPT_COMMAND}}"
      fi
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
