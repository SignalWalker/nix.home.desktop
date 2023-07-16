{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = lib.mkMerge [
    {
      home.packages = with pkgs; [cava];
      xdg.configFile."cava/config".text = ''
        [general]
        framerate = 30
        autosens = 1
        bars = 0
        sleep_timer = 12;

        [input]
        method = pulse
        source = auto
      '';
      signal.desktop.scratch.scratchpads = {
        "Shift+V" = {
          criteria = {app_id = "pavucontrol";};
          resize = 50;
          startup = "pavucontrol";
          autostart = true;
          automove = true;
        };
      };
      services.playerctld = {
        enable = true;
      };

      xdg.configFile."wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        }
      '';
    }
    (lib.mkIf config.system.isNixOS {
      home.packages = with pkgs; [
        pavucontrol
        # for pactl
        pulseaudio
      ];
    })
  ];
  meta = {};
}
