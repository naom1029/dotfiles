{ pkgs, hunkPkg, ... }:

let
  hunkFixed = hunkPkg.overrideAttrs (old: {
    dontFixup = false;
    postFixup = ''
      patchelf \
        --set-interpreter /lib64/ld-linux-x86-64.so.2 \
        --remove-rpath \
        $out/bin/hunk
    '';
  });
in
{
  programs.hunk = {
    enable = true;
    package = hunkFixed;
    settings = {
      theme = "auto";
      transparentBackground = true;
    };
    enableClaudeIntegration = true;
  };
}
