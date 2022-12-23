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
    signal.desktop.scratch.scratchpads = {
      "Shift+R" = {
        criteria = {app_id = "com.github.rssguard";};
        resize = 93;
        startup = "rssguard";
      };
    };
  };
  meta = {};
}
