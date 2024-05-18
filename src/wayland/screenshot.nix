{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {
    desktop.wayland = {
      screenshotScript = mkOption {
        type = types.path;
        default = ./scripts/screenshot;
      };
    };
  };
  disabledModules = [];
  imports = [];
  config = {
    home.packages = with pkgs; [
      grim
      slurp
      sway-contrib.grimshot
      libnotify
    ];
  };
  meta = {};
}