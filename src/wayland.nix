{ config
, pkgs
, lib
, ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.wayland;
in
{
  options.signal.desktop.wayland = with lib; {
    enable = (mkEnableOption "Wayland-specific configuration") // { default = true; };
    xwayland = {
      enable = (mkEnableOption "XWayland support") // { default = true; };
    };
    sessionVariables = mkOption {
      type = types.attrsOf (types.either types.int types.str);
      default = { };
    };
    startupCommands = mkOption {
      type = types.lines;
      default = "";
    };
    __systemdStartupScript = mkOption {
      type = types.path;
    };
    __startupScript = mkOption {
      type = types.path;
    };
    screenshotScript = mkOption {
      type = types.path;
      default = ./wayland/scripts/screenshot;
    };
  };
  imports = lib.signal.fs.path.listFilePaths ./wayland;
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # meta
      swaylock
      swayidle
      wev
      # screenshots
      grim
      slurp
    ];
    signal.desktop.wayland.sessionVariables = lib.mkDefault {
      MOZ_ENABLE_WAYLAND = 1;
      QT_QPA_PLATFORM = "wayland;xcb";
      WINIT_UNIX_BACKEND = "wayland";
    };
    systemd.user.targets."wayland-session" = {
      Unit = {
        Description = "wayland graphical session";
        BindsTo = [ "graphical-session.target" ];
        After = [ "graphical-session-pre.target" ];
        Wants = [ "graphical-session-pre.target" ];
      };
    };
    services.kanshi.systemdTarget = "wayland-session.target";
    services.swayidle.systemdTarget = "wayland-session.target";
    signal.desktop.wayland.__systemdStartupScript =
      let
        vars = config.signal.desktop.wayland.sessionVariables;
        keys = attrNames vars;
      in
      pkgs.writeScript "hm-wayland-systemd-startup-script" ''
        #! /usr/bin/env sh
        systemctl --user stop graphical-session.target graphical-session-pre.target
        /usr/bin/env dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
        systemctl --user start wayland-session.target
        ${config.signal.desktop.wayland.__startupScript}
      '';
    signal.desktop.wayland.__startupScript = pkgs.writeScript "hm-wayland-startup-script" ''
      #! /usr/bin/env sh
      ${cfg.startupCommands}
    '';
    # xdg.configFile."electron-flags.conf".text = ''
    #   --enable-features=UseOzonePlatform,WaylandWindowDecorations
    #   --ozone-platform=wayland
    # '';
  };
}
