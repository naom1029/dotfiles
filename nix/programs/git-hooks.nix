{ lib, config, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/src/github.com/naom1029/dotfiles";
in
{
  home.activation.installDotfilesGitHooks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -d "${dotfilesDir}/.git" ]; then
      mkdir -p "${dotfilesDir}/.git/hooks"

      cat > "${dotfilesDir}/.git/hooks/post-commit" << 'HOOK_EOF'
#!/usr/bin/env bash
# Skip during rebase, merge, or cherry-pick
if [ -d "$(git rev-parse --git-dir)/rebase-merge" ] || \
   [ -d "$(git rev-parse --git-dir)/rebase-apply" ] || \
   [ -f "$(git rev-parse --git-dir)/MERGE_HEAD" ] || \
   [ -f "$(git rev-parse --git-dir)/CHERRY_PICK_HEAD" ]; then
  exit 0
fi

if git diff HEAD^..HEAD --name-only 2>/dev/null | grep -qE '^(flake\.(nix|lock)|nix/|config/)'; then
  echo "Nix/config changed. Running home-manager switch..."
  home-manager switch --flake . --impure 2>&1 | tail -5
fi
HOOK_EOF
      chmod +x "${dotfilesDir}/.git/hooks/post-commit"

      cat > "${dotfilesDir}/.git/hooks/post-checkout" << 'HOOK_EOF'
#!/usr/bin/env bash
# $3=1 means branch switch, $3=0 means file checkout
if [ "$3" = "0" ]; then
  exit 0
fi

if [ -d "$(git rev-parse --git-dir)/rebase-merge" ] || \
   [ -d "$(git rev-parse --git-dir)/rebase-apply" ]; then
  exit 0
fi

if git diff HEAD@{1}..HEAD --name-only 2>/dev/null | grep -qE '^(flake\.(nix|lock)|nix/|config/)'; then
  echo "Nix/config changed. Running home-manager switch..."
  home-manager switch --flake . --impure 2>&1 | tail -5
fi
HOOK_EOF
      chmod +x "${dotfilesDir}/.git/hooks/post-checkout"

      cat > "${dotfilesDir}/.git/hooks/post-merge" << 'HOOK_EOF'
#!/usr/bin/env bash
if git diff HEAD@{1}..HEAD --name-only 2>/dev/null | grep -qE '^(flake\.(nix|lock)|nix/|config/)'; then
  echo "Nix/config changed. Running home-manager switch..."
  home-manager switch --flake . --impure 2>&1 | tail -5
fi
HOOK_EOF
      chmod +x "${dotfilesDir}/.git/hooks/post-merge"

      cat > "${dotfilesDir}/.git/hooks/post-rewrite" << 'HOOK_EOF'
#!/usr/bin/env bash
if [ "$1" != "rebase" ]; then
  exit 0
fi

if git diff ORIG_HEAD..HEAD --name-only 2>/dev/null | grep -qE '^(flake\.(nix|lock)|nix/|config/)'; then
  echo "Nix/config changed after rebase. Running home-manager switch..."
  home-manager switch --flake . --impure 2>&1 | tail -5
fi
HOOK_EOF
      chmod +x "${dotfilesDir}/.git/hooks/post-rewrite"
    fi
  '';
}
