inputs @ {
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.x11;
in {
  options.signal.desktop.x11.taskbar = with lib; {
    enable = (mkEnableOption "task/status bar") // {default = true;};
  };
  imports = [];
  config = lib.mkIf (cfg.enable && cfg.taskbar.enable) {
    services.polybar = {
      enable = cfg.taskbar.enable;
      script = ""; # handled by xmonad
      package = pkgs.polybar.override {
        alsaSupport = true;
        mpdSupport = config.services.mpd.enable;
        pulseSupport = true;
        iwSupport = true;
        nlSupport = true;
        i3Support = false;
        i3GapsSupport = false;
      };
      settings = let
        colors = {
          background = "#AA222222";
          background-alt = "#AA222222";
          foreground = "#dfdfdf";
          foreground-alt = "#555";
          foreground-notice = "#7979df";
          foreground-alert = "#df7979";
          primary = "#ffb52a";
          secondary = "#e60053";
          alert = "#bd2c40";
        };
        bars = import ./polybar/bars.nix {inherit colors;} inputs;
        modules = import ./polybar/modules.nix {inherit colors;} inputs;
      in (bars
        // modules
        // {
          "global/wm" = {
            margin-top = 5;
            margin-bottom = 5;
          };
          settings = {
            screenchange-reload = true;
            throttle-output = 5;
            throttle-output-for = 10;
          };
        });
    };
  };
}
