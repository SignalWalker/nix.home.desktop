{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.wayland.menu;
in {
  options.signal.desktop.wayland.menu = with lib; {
    enable = (mkEnableOption "launcher menu config") // {default = true;};
    defaultCommand = mkOption {
      type = types.str;
      default = "wofi --show drun";
    };
  };
  imports = [];
  config = lib.mkIf (cfg.enable
    && config.signal.desktop.wayland.enable) {
    home.packages = with pkgs; [
      wofi
    ];
  };
}
