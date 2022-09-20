{
  config,
  pkgs,
  lib,
  profile,
  ...
}:
with builtins; let
  cfg = config.signal.desktop.x11;
  scfg = config.signal.desktop.x11.xsession;
in {
  options.signal.desktop.x11.xsession = with lib; {
  };
  config = lib.mkIf cfg.enable {
    xsession = let
      xmonad = "xmonad";
    in {
      enable = true;
      scriptPath = ".config/xsession";
      profilePath = ".config/xprofile";
      numlock.enable = true;
      preferStatusNotifierItems = true;
      windowManager.command = "sx ${xmonad}";
      # windowManager.xmonad = {
      #   enable = true;
      #   enableContribAndExtras = true;
      # };
    };
  };
}
