{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  launcher = config.desktop.launcher;
  wofi = config.programs.wofi;
in {
  options = with lib; {
    desktop.launcher.wofi = {
      enable = mkEnableOption "wofi config";
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf launcher.wofi.enable {
    desktop.launcher = {
      drun = "${wofi.package}/bin/wofi --show=drun";
      run = "${wofi.package}/bin/wofi --show=run";
    };
    programs.wofi = {
      enable = true;
      settings = {
        layer = "overlay";
        width = "50%";
        height = "40%";
        dynamic_lines = true;
        normal_window = false;
        allow_images = true;
        allow_markup = true;
        matching = "fuzzy";
        insensitive = true;
        term = config.desktop.terminal.command;
      };
    };
  };
  meta = {};
}