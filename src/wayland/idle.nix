{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.wayland;
  idl = cfg.idle;
in {
  options.signal.desktop.wayland.idle = with lib; {
    enable = (mkEnableOption "idle daemon") // {default = true;};
  };
  imports = [];
  config = lib.mkIf (cfg.enable && idl.enable) {
    services.swayidle = let
      lock = "swaylock -f";
      unlock = "killall swaylock";
      outputOn = "swaymsg output '*' dpms on";
      outputOff = "swaymsg output '*' dpms off";
    in {
      enable = true;
      package =
        if config.system.isNixOS
        then lib.signal.home.linkSystemApp pkgs {app = "swayidle";}
        else pkgs.swayidle;
      systemdTarget = "wayland-session.target";
      events = [
        {
          event = "before-sleep";
          command = "playerctl pause";
        }
        {
          event = "before-sleep";
          command = lock;
        }
        {
          event = "lock";
          command = lock;
        }
        {
          event = "unlock";
          command = unlock;
        }
        {
          event = "after-resume";
          command = outputOn;
        }
      ];
      timeouts = [
        {
          timeout = 60;
          command = "if pgrep -x swaylock; then ${outputOff}; fi";
          resumeCommand = outputOn;
        }
        {
          timeout = 900;
          command = outputOff;
          resumeCommand = outputOn;
        }
      ];
    };
  };
}
