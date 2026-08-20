{ pkgs, lib, ... }:

let
  # WezTerm 同梱の Symbols Nerd Font は 20240203 版で止まっており、nf-dev-yaml (U+E8EB) 等の
  # 新しいグリフを含まない。Windows にフォントをインストールしても同梱フォントの方が優先される
  # ため、font_dirs 経由で読ませる必要がある（font_dirs > BuiltIn > FontConfig）。
  symbolsFont =
    "${pkgs.nerd-fonts.symbols-only}/share/fonts/truetype/NerdFonts/Symbols/SymbolsNerdFontMono-Regular.ttf";
in
{
  home.activation.deployWezterm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    CMD_EXE="/mnt/c/Windows/System32/cmd.exe"
    [ -x "$CMD_EXE" ] || CMD_EXE="cmd.exe"
    WIN_USER=$("$CMD_EXE" /c "echo %USERNAME%" 2>/dev/null | tr -d '\r' || true)
    DEST="/mnt/c/Users/$WIN_USER/.config/wezterm"
    SRC="${../../config/wezterm}"
    if [ -n "$WIN_USER" ] && [ -d "/mnt/c/Users/$WIN_USER" ]; then
      mkdir -p "$DEST"
      cp -f "$SRC/wezterm.lua" "$DEST/"
      cp -f "$SRC/keybinds.lua" "$DEST/"
      cp -f "$SRC/zen-mode.lua" "$DEST/"
      install -D -m 644 "${symbolsFont}" "$DEST/fonts/SymbolsNerdFontMono-Regular.ttf"
    fi
  '';
}
