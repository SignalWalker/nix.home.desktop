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
    startupCommands = mkOption {
      type = types.lines;
      default = "";
    };
  };
  config = lib.mkIf cfg.enable {
    home.file."sxrc" = lib.mkForce {
      text = let
        ssnpath = "${config.home.homeDirectory}/${config.xsession.scriptPath}";
      in ''
        #! /usr/bin/env sh
        logger -t sx "Running startup commands..."
        ${scfg.startupCommands}
        logger -t sx "Running ${ssnpath}"
        . ${ssnpath}
      '';
      target = ".config/sx/sxrc";
      executable = true;
    };
    xsession = let
      xmonad = "xmonad";
    in {
      enable = true;
      scriptPath = ".config/xsession";
      profilePath = ".config/xprofile";
      numlock.enable = true;
      preferStatusNotifierItems = true;
      windowManager.command = "${xmonad}";
      # windowManager.xmonad = {
      #   enable = true;
      #   enableContribAndExtras = true;
      # };
    };
  };
}
