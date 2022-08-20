inputs @ {
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.x11;
  ccfg = config.signal.desktop.x11.compositor;
in {
  options.signal.desktop.x11.compositor = with lib; {
    enable = (mkEnableOption "X11 compositor") // {default = true;};
  };
  imports = [];
  config = lib.mkIf (cfg.enable && ccfg.enable) {
    services.picom = {
      enable = true;
      package =
        if (config.system.isNixOS or true)
        then pkgs.picom
        else (lib.signal.linkSystemApp pkgs {app = "picom";});
      settings = {
        blur = {
          background = false;
          kern = "3x3box";
          background-exclude = [
            "window_type = 'dock'"
            "window_type = 'desktop'"
            "_GTK_FRAME_EXTENTS@:c"
          ];
        };
        corner = {
          radius = 0;
        };
        rounded-corners = {
          exclude = [
            "window_type = 'dock'"
            "window_type = 'desktop'"
          ];
        };
        fading = false;
        glx = {
          no-stencil = true;
          no-rebind-pixmap = true;
        };
        shadow = false;
        inactive = {
          opacity = "1.0";
          opacity-override = false;
        };
      };
    };
    signal.desktop.x11.xsession.startupCommands = "picom &";
  };
}
