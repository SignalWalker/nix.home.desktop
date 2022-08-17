{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.services.wayland.compositor.hyprland;
in {
  options.services.wayland.compositor.hyprland = with lib; {
    enable = mkEnableOption "hyprland wayland compositor";
  };
  imports = [];
  config = lib.mkIf (config.services.wayland.enable && cfg.enable) {
    wayland.windowManager.hyprland = {
      enable = cfg.compositor.hyprland.enable;
      xwayland = cfg.xwayland.enable;
      extraConfig =
        (readFile ./hyprland/hyprland.conf)
        + ''
          exec-once=${config.services.wayland.__startupScript}
        '';
      systemdIntegration = false; # this is bad actually; we're starting graphical-session.target in the generic wayland startup script
    };
  };
}
