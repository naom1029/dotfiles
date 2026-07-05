{ pkgs, lib, ... }:

{
  home.activation.deployWezterm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    WIN_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r' || true)
    DEST="/mnt/c/Users/$WIN_USER/.config/wezterm"
    SRC="${../../config/wezterm}"
    if [ -n "$WIN_USER" ] && [ -d "/mnt/c/Users/$WIN_USER" ]; then
      mkdir -p "$DEST"
      cp -f "$SRC/wezterm.lua" "$DEST/"
      cp -f "$SRC/keybinds.lua" "$DEST/"
      cp -f "$SRC/zen-mode.lua" "$DEST/"
    fi
  '';
}
