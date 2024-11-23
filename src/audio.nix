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
      # FIX :: disabled cava 2024-11-19 for build failure
      # home.packages = with pkgs; [cava];
      # xdg.configFile."cava/config".text = ''
      #   [general]
      #   framerate = 30
      #   autosens = 1
      #   bars = 0
      #   sleep_timer = 12;
      #
      #   [input]
      #   method = pulse
      #   source = auto
      # '';
      # ${readFile config.desktop.theme.inputs.cava}
      desktop.scratchpads = {
        "Shift+V" = {
          criteria = {app_id = "com.saivert.pwvucontrol";};
          resize = 50;
          startup = "pwvucontrol";
          systemdCat = true;
          autostart = false;
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
        pwvucontrol
        pulseaudio # for pactl
        coppwr
        qpwgraph
        # easyeffects # FIX :: disabled 2024-08-01 for build failure
      ];
    })
  ];
  meta = {};
}
