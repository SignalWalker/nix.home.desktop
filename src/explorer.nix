{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = {
    home.packages = with pkgs.libsForQt5; [
      dolphin
      dolphin-plugins
      kdegraphics-thumbnailers
    ];
    signal.desktop.scratch.scratchpads = {
      "Shift+Slash" = {
        criteria = {app_id = "org.kde.dolphin";};
        resize = 83;
        startup = "dolphin";
      };
    };
  };
  meta = {};
}
