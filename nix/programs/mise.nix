{ pkgs, ... }:

{
  programs.mise = {
    enable = true;
    enableBashIntegration = true;
    # プロジェクト直下に mise.toml / .tool-versions があれば cd 時に自動で切り替わる。
    # 無い場合のフォールバックとしてグローバル既定バージョンをここで指定する。
    globalConfig = {
      tools = {
        node = "latest";
        pnpm = "latest";
        bun = "latest";
        python = "latest";
        go = "latest";
        rust = "latest";
      };
    };
  };
}
