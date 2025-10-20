{
  config,
  pkgs,
  lib,
  ...
}:
{
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
          criteria = {
            app_id = "com.saivert.pwvucontrol";
          };
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
      home.packages = [
        pkgs.pavucontrol
        pkgs.pwvucontrol
        pkgs.pulseaudio # for pactl
        pkgs.coppwr
        pkgs.qpwgraph
        pkgs.easyeffects
      ];
    })
    {
      desktop.keybinds = {
        mediaPrev = {
          modifiers = [ ];
          keysym = "XF86AudioPrev";
          description = "rewind media";
          hypr = {
            enable = true;
            locked = true;
            dispatcher = lib.mkDefault "execr";
            args = lib.mkDefault [ "playerctl -s previous" ];
          };
        };
        mediaToggle = {
          modifiers = [ ];
          keysym = "XF86AudioPlay";
          description = "play/pause media";
          hypr = {
            enable = true;
            locked = true;
            dispatcher = lib.mkDefault "execr";
            args = lib.mkDefault [ "playerctl -s play-pause" ];
          };
        };
        mediaNext = {
          modifiers = [ ];
          keysym = "XF86AudioNext";
          description = "fast-forward media";
          hypr = {
            enable = true;
            locked = true;
            dispatcher = lib.mkDefault "execr";
            args = lib.mkDefault [ "playerctl -s next" ];
          };
        };
        volumeRaise = {
          modifiers = [ ];
          keysym = "XF86AudioRaiseVolume";
          description = "raise volume";
          hypr = {
            enable = true;
            repeat = true;
            locked = true;
            dispatcher = lib.mkDefault "execr";
            args = lib.mkDefault [ "pactl set-sink-volume @DEFAULT_SINK@ +1dB" ];
          };
        };
        volumeLower = {
          modifiers = [ ];
          keysym = "XF86AudioLowerVolume";
          description = "lower volume";
          hypr = {
            enable = true;
            repeat = true;
            locked = true;
            dispatcher = lib.mkDefault "execr";
            args = lib.mkDefault [ "pactl set-sink-volume @DEFAULT_SINK@ -1dB" ];
          };
        };
        volumeMute = {
          modifiers = [ ];
          keysym = "XF86AudioMute";
          description = "mute audio";
          hypr = {
            enable = true;
            locked = true;
            dispatcher = lib.mkDefault "execr";
            args = lib.mkDefault [ "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" ];
          };
        };
        micLower = {
          modifiers = [ "ALT" ];
          keysym = "XF86AudioLowerVolume";
          description = "lower mic volume";
          hypr = {
            enable = true;
            repeat = true;
            dispatcher = lib.mkDefault "execr";
            args = lib.mkDefault [ "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SOURCE@ 1%-" ];
          };
        };
        micRaise = {
          modifiers = [ "ALT" ];
          keysym = "XF86AudioRaiseVolume";
          description = "raise mic volume";
          hypr = {
            enable = true;
            repeat = true;
            dispatcher = lib.mkDefault "execr";
            args = lib.mkDefault [ "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SOURCE@ 1%+" ];
          };
        };
        micMute = {
          modifiers = [ ];
          keysym = "XF86AudioMicMute";
          description = "mute microphone";
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "execr";
            args = lib.mkDefault [ "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" ];
          };
        };
        micMuteAlt = {
          modifiers = [ "ALT" ];
          keysym = "XF86AudioMute";
          description = "mute microphone";
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "execr";
            args = lib.mkDefault [ "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" ];
          };
        };
      };
    }
  ];
  meta = { };
}
