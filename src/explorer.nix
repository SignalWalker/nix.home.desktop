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
