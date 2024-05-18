{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  wayland = config.desktop.wayland;
  launcher = config.desktop.launcher;
in {
  options = with lib; {
    desktop.launcher = {
      enable = mkEnableOption "desktop launcher";
      run = mkOption {
        type = types.str;
      };
      drun = mkOption {
        type = types.str;
        default = launcher.run;
      };
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf launcher.enable {
    desktop.launcher = {
      yofi.enable = wayland.enable;
    };
  };
  meta = {};
}
