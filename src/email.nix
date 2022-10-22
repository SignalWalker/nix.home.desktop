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
    signal.desktop.wayland.compositor.scratchpads = [
      {
        kb = "Shift+E";
        criteria = {app_id = "^thunderbird*";};
        resize = 93;
        startup = "thunderbird-nightly";
      }
    ];
  };
  meta = {};
}
