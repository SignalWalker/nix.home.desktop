{hyprland, ...}: {
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.services.wayland;
in {
  options.services.wayland = with lib; {
    enable = mkEnableOption "Wayland-specific configuration";
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
    __startupScript = mkOption {
      type = types.path;
    };
    screenshotCmd = mkOption {
      type = types.str;
      default = "grim -l 9 -g \"$(slurp -d)\" - | wl-clip -i -selection clipboard";
    };
  };
  imports = [
    hyprland.homeManagerModules.default
    ./compositor.nix
    ./menu.nix
    ./taskbar.nix
    ./notifications.nix
    ./wallpaper.nix
  ];
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
    services.wayland.sessionVariables = lib.mkDefault {
      MOZ_ENABLE_WAYLAND = 1;
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
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
    services.wayland.__startupScript = pkgs.writeScript "hm-wayland-startup-script" ''
      #! /usr/bin/env sh
      systemctl --user start wayland-session.target
      ${cfg.startupCommands}
    '';
    # xdg.configFile."electron-flags.conf".text = ''
    #   --enable-features=UseOzonePlatform,WaylandWindowDecorations
    #   --ozone-platform=wayland
    # '';
  };
}
