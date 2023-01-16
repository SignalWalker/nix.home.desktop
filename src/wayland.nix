{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.wayland;
in {
  options.signal.desktop.wayland = with lib; {
    enable = (mkEnableOption "Wayland-specific configuration") // {default = true;};
    xwayland = {
      enable = (mkEnableOption "XWayland support") // {default = true;};
    };
    sessionVariables = mkOption {
      type = types.attrsOf (types.either types.int types.str);
      default = {};
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
    signal.desktop.wayland.sessionVariables = {
      MOZ_ENABLE_WAYLAND = lib.mkDefault 1;
      QT_QPA_PLATFORM = lib.mkDefault "wayland;xcb";
      WINIT_UNIX_BACKEND = lib.mkDefault "wayland";
      WLR_RENDERER = lib.mkDefault "vulkan";
    };
    systemd.user.targets."wayland-session" = {
      Unit = {
        Description = "wayland graphical session";
        BindsTo = ["graphical-session.target"];
        After = ["graphical-session-pre.target"];
        Wants = ["graphical-session-pre.target" "xdg-desktop-autostart.target"];
      };
    };
    services.kanshi.systemdTarget = "wayland-session.target";
    services.swayidle.systemdTarget = "wayland-session.target";
    signal.desktop.wayland.__systemdStartupScript = let
      vars = config.signal.desktop.wayland.sessionVariables;
      keys = ["DISPLAY" "WAYLAND_DISPLAY" "SWAYSOCK" "XDG_CURRENT_DESKTOP"] ++ (attrNames vars);
      keysStr = toString keys;
    in
      pkgs.writeScript "hm-wayland-systemd-startup-script" (''
          #! /usr/bin/env sh

        ''
        + (std.concatStringsSep "\n" (map (key: "export ${key}='${toString vars.${key}}'") (attrNames vars)))
        + ''

          systemctl --user import-environment ${keysStr}

          # `hash` checks for the existence of the dbus command
          hash dbus-update-activation-environment 2>/dev/null \
            && dbus-update-activation-environment --systemd ${keysStr}

          systemctl --user start wayland-session.target

          ${config.signal.desktop.wayland.__startupScript}
        '');
    signal.desktop.wayland.__startupScript = pkgs.writeScript "hm-wayland-startup-script" ''
      #! /usr/bin/env sh
      ${cfg.startupCommands}
    '';
    xdg.configFile."electron-flags.conf".text = ''
      --enable-features=WaylandWindowDecorations
      --ozone-platform-hint=auto
    '';
  };
}
