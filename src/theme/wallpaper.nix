{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  wlp = config.signal.desktop.theme.wallpaper;
in {
  options = with lib; {
    signal.desktop.theme.wallpaper = {
      default = mkOption {
        type = types.path;
        default = ./wallpaper/default.png;
      };
    };
  };
  disabledModules = [];
  imports = [];
  config = {};
  meta = {};
}
