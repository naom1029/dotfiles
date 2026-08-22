{ pkgs, hunkPkg, ... }:

let
  # bun 1.3.13 は standalone バイナリの .bun ペイロードを、PT_GNU_STACK を転用した
  # 独立の PT_LOAD として埋め込む。この PT_LOAD が vaddr 昇順に並ばないため、
  # glibc 2.42 の ld.so が起動に失敗する (oven-sh/bun#29963)。
  # interpreter を同一パスで再設定するだけで patchelf が program header を並べ直す。
  # bun 1.3.14 (oven-sh/bun#29967) で修正済みなので、nixpkgs 側が追随したら削除可。
  # strip と --set-rpath は .bun ペイロードを破壊するため使用しないこと。
  hunkFixed = hunkPkg.overrideAttrs (old: {
    dontFixup = false;
    postFixup = ''
      bin=$out/bin/.hunk-wrapped
      patchelf --set-interpreter "$(patchelf --print-interpreter $bin)" $bin
    '';
  });
in
{
  programs.hunk = {
    enable = true;
    package = hunkFixed;
    settings = {
      theme = "auto";
      transparentBackground = false;
    };
    enableClaudeIntegration = true;
  };
}
