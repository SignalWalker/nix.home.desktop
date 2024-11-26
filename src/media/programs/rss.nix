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
    home.packages = with pkgs; [fluent-reader];
    desktop.scratchpads = {
      "Shift+R" = {
        criteria = {
          instance = "fluent-reader";
          # app_id = "io.github.martinrotter.rssguard";
          # title = "^(\\[[0-9]*\\] )?RSS Guard [0-9]\\.[0-9]\\.[0-9]";
        };
        resize = 93;
        startup = "fluent-reader";
        systemdCat = true;
        automove = true;
      };
    };
  };
  meta = {};
}
