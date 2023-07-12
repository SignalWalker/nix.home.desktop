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
        criteria = {
          app_id = "io.github.martinrotter.rssguard";
          title = "^(\\[[0-9]*\\] )?RSS Guard [0-9]\\.[0-9]\\.[0-9]";
        };
        resize = 93;
        startup = "rssguard";
        automove = true;
        autostart = true;
      };
    };
  };
  meta = {};
}
