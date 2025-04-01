{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  launcher = config.desktop.launcher;
  fuzzel = config.programs.fuzzel;
in {
  options = with lib; {
    desktop.launcher.fuzzel = {
      enable = mkEnableOption "fuzzel config";
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf launcher.fuzzel.enable {
    desktop.launcher = {
      drun = "${fuzzel.package}/bin/fuzzel";
      run = "${fuzzel.package}/bin/fuzzel";
    };
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          "use-bold" = true;
          "filter-desktop" = true;
          "terminal" = "kitty";
          "launch-prefix" = "uwsm-app -- ";
        };
      };
    };
  };
  meta = {};
}
