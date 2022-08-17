{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.services.wayland.compositor.river;
in {
  options.services.wayland.compositor.river = with lib; {
    enable = mkEnableOption "river wayland compositor";
    package = mkOption {
      type = types.package;
      default = pkgs.river;
    };
    layout-generators = mkOption {
      type = types.listOf types.package;
      default = [pkgs.rivercarro];
    };
  };
  imports = [];
  config = lib.mkIf (config.services.wayland.enable && cfg.enable) {
    home.packages =
      [
        cfg.package
      ]
      ++ cfg.layout-generators;
    xdg.configFile."river/init" = {
      text = ''
        #! /usr/bin/env sh
        exec ${config.services.wayland.__startupScript}
        exec ${./river/init.zsh}
      '';
      executable = true;
    };
  };
}
