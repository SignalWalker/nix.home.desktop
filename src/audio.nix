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
    }
    (lib.mkIf config.system.isNixOS {
      home.packages = with pkgs; [
        pavucontrol
        pwvucontrol
        pulseaudio # for pactl
        coppwr
        qpwgraph
        easyeffects
      ];
    })
  ];
  meta = {};
}
