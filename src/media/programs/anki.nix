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
    home.packages = with pkgs; [
      anki-bin
    ];
    signal.desktop.scratch.scratchpads = {
      "Shift+A" = {
        criteria = {app_id = "anki";};
        resize = 83;
        startup = "anki";
        systemdCat = true;
        autostart = true;
        automove = false;
      };
    };
  };
  meta = {};
}
