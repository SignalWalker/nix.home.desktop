{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.services.wayland.menu;
in {
  options.services.wayland.menu = with lib; {
    enable = (mkEnableOption "launcher menu config") // {default = true;};
    defaultCommand = mkOption {
      type = types.str;
      default = "wofi --show drun";
    };
  };
  imports = [];
  config = lib.mkIf (cfg.enable
    && config.services.wayland.enable) {
    home.packages = with pkgs; [
      wofi
    ];
  };
}
