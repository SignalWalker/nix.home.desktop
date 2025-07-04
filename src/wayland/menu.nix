{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  std = pkgs.lib;
  launcher = config.desktop.launcher;
in
{
  options = with lib; { };
  imports = lib.signal.fs.path.listFilePaths ./menu;
  config = lib.mkIf (launcher.enable) {
    desktop.launcher = {
      fuzzel.enable = true;
    };
  };
}
