{
  config,
  osConfig,
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
    systemd = {
      targetName = mkOption {
        type = types.str;
        readOnly = true;
        default = "wayland-session";
      };
      target = mkOption {
        type = types.str;
        readOnly = true;
        default = "${cfg.systemd.targetName}.target";
      };
    };
    # __systemdStartupScript = mkOption {
    #   type = types.path;
    # };
    # __startupScript = mkOption {
    #   type = types.path;
    # };
  };
  imports = lib.signal.fs.path.listFilePaths ./wayland;
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # meta
      wev
      wl-clipboard
      xdg-utils
    ];
    signal.desktop.wayland.sessionVariables = lib.mkMerge [
      {
        MOZ_ENABLE_WAYLAND = lib.mkDefault 1;
        QT_QPA_PLATFORM = lib.mkDefault "wayland;xcb";
        WINIT_UNIX_BACKEND = lib.mkDefault "wayland";
      }
      (lib.mkIf osConfig.hardware.nvidia.modesetting.enable {
        WLR_RENDERER = lib.mkDefault "vulkan";
        WLR_NO_HARDWARE_CURSORS = lib.mkDefault "1";
      })
    ];
    systemd.user.targets."${cfg.systemd.targetName}" = {
      Unit = {
        Description = "wayland graphical session";
        BindsTo = ["graphical-session.target"];
        Wants = ["graphical-session-pre.target" "xdg-desktop-autostart.target"];
        After = ["graphical-session-pre.target"];
        Before = ["xdg-desktop-autostart.target"];
      };
    };
    # signal.desktop.wayland.__systemdStartupScript = let
    #   vars = {}; # config.signal.desktop.wayland.sessionVariables;
    #   keys = ["DISPLAY" "WAYLAND_DISPLAY" "SWAYSOCK" "XDG_CURRENT_DESKTOP"] ++ (attrNames vars);
    #   keysStr = toString keys;
    # in
    #   # ''
    #   # + (std.concatStringsSep "\n" (map (key: "export ${key}='${toString vars.${key}}'") (attrNames vars)))
    #   # + ''
    #   pkgs.writeScript "hm-wayland-systemd-startup-script" ''
    #     #! /usr/bin/env sh
    #
    #     if [[ "$(systemctl --user is-active ${cfg.systemd.target})" != "active" ]]; then
    #       systemctl --user import-environment ${keysStr}
    #
    #       # `hash` checks for the existence of the dbus command
    #       hash dbus-update-activation-environment 2>/dev/null \
    #         && dbus-update-activation-environment --systemd ${keysStr}
    #
    #       systemctl --user start ${cfg.systemd.target}
    #     fi
    #
    #     ${config.signal.desktop.wayland.__startupScript}
    #   '';
    xdg.configFile."electron-flags.conf".text = ''
      --enable-features=WaylandWindowDecorations
      --ozone-platform-hint=auto
    '';
  };
}
