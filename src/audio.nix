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
      "Shift+V" = {
        criteria = {app_id = "pavucontrol";};
        resize = 50;
        startup = "pavucontrol";
        autostart = true;
        automove = true;
      };
    };
    services.playerctld = {
      enable = true;
    };
  };
  meta = {};
}
