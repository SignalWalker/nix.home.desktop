{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  wayland = config.desktop.wayland;
in {
  options.desktop.wayland = with lib; {
    enable = (mkEnableOption "Wayland-specific configuration") // {default = true;};
    xwayland = {
      enable = (mkEnableOption "XWayland support") // {default = true;};
    };
    # sessionVariables = mkOption {
    #   type = types.attrsOf (types.either types.int types.str);
    #   default = {};
    # };
    startupCommands = mkOption {
      type = types.lines;
      default = "";
    };
    systemd = {
      targetName = mkOption {
        type = types.str;
        readOnly = true;
        default = "wayland-session@";
      };
      target = mkOption {
        type = types.str;
        readOnly = true;
        default = "${wayland.systemd.targetName}.target";
      };
    };
  };
  imports = lib.signal.fs.path.listFilePaths ./wayland;
  config = lib.mkIf wayland.enable {
    home.packages = with pkgs; [
      # meta
      wev
      wl-clipboard
      xdg-utils
    ];
    # using UWSM
    # systemd.user.targets."${wayland.systemd.targetName}" = {
    #   Unit = {
    #     Description = "wayland graphical session";
    #     BindsTo = ["graphical-session.target"];
    #     Wants = ["graphical-session-pre.target" "xdg-desktop-autostart.target"];
    #     After = ["graphical-session-pre.target"];
    #     Before = ["xdg-desktop-autostart.target"];
    #   };
    # };
    xdg.configFile."electron-flags.conf".text = ''
      --enable-features=WaylandWindowDecorations
      --ozone-platform-hint=auto
    '';
  };
}
