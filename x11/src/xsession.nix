{
  config,
  pkgs,
  lib,
  profile,
  ...
}:
with builtins; let
  cfg = config.services.X11.xsession;
in {
  options.services.X11.xsession = with lib; {
    startupCommands = mkOption {
      type = types.lines;
      default = "";
    };
  };
  config = lib.mkIf config.services.X11.enable {
    home.file."sxrc" = lib.mkForce {
      text = let
        ssnpath = "${config.home.homeDirectory}/${config.xsession.scriptPath}";
      in ''
        #! /usr/bin/env sh
        logger -t sx "Running startup commands..."
        ${cfg.startupCommands}
        logger -t sx "Running ${ssnpath}"
        . ${ssnpath}
      '';
      target = ".config/sx/sxrc";
      executable = true;
    };
    xsession = let
      xmonad = "xmonad";
    in {
      enable = config.services.X11.enable;
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
