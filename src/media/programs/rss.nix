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
    home.packages = with pkgs; [rssguard];
    signal.desktop.wayland.compositor.scratchpads = [
      {
        kb = "Shift+R";
        criteria = {app_id = "rssguard";};
        resize = 83;
        startup = "rssguard";
      }
    ];
  };
  meta = {};
}
