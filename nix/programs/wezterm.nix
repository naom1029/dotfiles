{ pkgs, lib, ... }:

{
  home.activation.deployWezterm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    DEST="/mnt/c/Users/$WIN_USER/.config/wezterm"
    SRC="${../../config/wezterm}"
    if [ -d "/mnt/c/Users/$WIN_USER" ]; then
      mkdir -p "$DEST"
      cp -f "$SRC/wezterm.lua" "$DEST/"
      cp -f "$SRC/keybinds.lua" "$DEST/"
      cp -f "$SRC/zen-mode.lua" "$DEST/"
    fi
  '';
}
