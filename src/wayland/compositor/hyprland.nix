{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.wayland.compositor.hyprland;
in {
  options.signal.desktop.wayland.compositor.hyprland = with lib; {
    enable = mkEnableOption "hyprland wayland compositor";
  };
  imports = [];
  config = lib.mkIf (config.signal.desktop.wayland.enable && cfg.enable) {
    # wayland.windowManager.hyprland = {
    #   enable = cfg.enable;
    #   xwayland = cfg.xwayland.enable;
    #   extraConfig =
    #     (readFile ./hyprland/hyprland.conf)
    #     + ''
    #       exec-once=${config.signal.desktop.wayland.__startupScript}
    #     '';
    #   systemdIntegration = false; # this is bad actually; we're starting graphical-session.target in the generic wayland startup script
    # };
  };
}
