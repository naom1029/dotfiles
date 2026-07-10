{ config, ... }:

{
  xdg.enable = true;

  home.sessionVariables = {
    # history → XDG_STATE_HOME
    HISTFILE = "${config.xdg.stateHome}/bash/history";
    SQLITE_HISTORY = "${config.xdg.stateHome}/sqlite_history";
    PYTHON_HISTORY = "${config.xdg.stateHome}/python_history";
    LESSHISTFILE = "${config.xdg.stateHome}/lesshst";
    MYSQL_HISTFILE = "${config.xdg.dataHome}/mysql_history";

    # config → XDG_CONFIG_HOME
    DOCKER_CONFIG = "${config.xdg.configHome}/docker";
    EASYOCR_MODULE_PATH = "${config.xdg.configHome}/EasyOCR";

    # data → XDG_DATA_HOME
    GOPATH = "${config.xdg.dataHome}/go";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";
    AZURE_CONFIG_DIR = "${config.xdg.dataHome}/azure";

    # cache → XDG_CACHE_HOME
    NUGET_PACKAGES = "${config.xdg.cacheHome}/NuGetPackages";
  };

  home.sessionPath = [
    "${config.xdg.dataHome}/cargo/bin"
    "${config.xdg.dataHome}/go/bin"
  ];

  home.shellAliases = {
    wget = "wget --hsts-file=\"${config.xdg.dataHome}/wget-hsts\"";
  };
}
