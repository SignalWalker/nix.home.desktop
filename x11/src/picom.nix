inputs@{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.services.X11;
in {
  options.services.X11.compositor = with lib; {
    enable = (mkEnableOption "compositor") // {default = true;};
  };
  imports = [];
  config = lib.mkIf (cfg.enable && cfg.compositor.enable) {
    services.picom = {
      enable = true;
      package = if (config.home.impure or false)
        then (pkgs.wrapSystemApp {app = "picom";})
        else pkgs.picom;
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
    services.X11.xsession.startupCommands = "picom &";
  };
}
