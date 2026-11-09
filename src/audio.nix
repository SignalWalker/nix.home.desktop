{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkMerge [
    {
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
        # pkgs.coppwr
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
          allowWhileSessionLocked = true;
          umbriel = {
            enable = true;
            action = lib.mkDefault "spawn";
            args = lib.mkDefault [ "playerctl -s previous" ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "playerctl -s previous" ];
          };
        };
        mediaToggle = {
          modifiers = [ ];
          keysym = "XF86AudioPlay";
          description = "play/pause media";
          allowWhileSessionLocked = true;
          umbriel = {
            enable = true;
            action = lib.mkDefault "spawn";
            args = lib.mkDefault [ "playerctl -s play-pause" ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "playerctl -s play-pause" ];
          };
        };
        mediaNext = {
          modifiers = [ ];
          keysym = "XF86AudioNext";
          description = "fast-forward media";
          allowWhileSessionLocked = true;
          umbriel = {
            enable = true;
            action = lib.mkDefault "spawn";
            args = lib.mkDefault [ "playerctl -s next" ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "playerctl -s next" ];
          };
        };
        volumeRaise = {
          modifiers = [ ];
          keysym = "XF86AudioRaiseVolume";
          description = "raise volume";
          repeating = true;
          allowWhileSessionLocked = true;
          umbriel = {
            enable = true;
            action = lib.mkDefault "spawn";
            args = lib.mkDefault [ "pactl set-sink-volume @DEFAULT_SINK@ +1dB" ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "pactl set-sink-volume @DEFAULT_SINK@ +1dB" ];
          };
        };
        volumeLower = {
          modifiers = [ ];
          keysym = "XF86AudioLowerVolume";
          description = "lower volume";
          repeating = true;
          allowWhileSessionLocked = true;
          umbriel = {
            enable = true;
            action = lib.mkDefault "spawn";
            args = lib.mkDefault [ "pactl set-sink-volume @DEFAULT_SINK@ -1dB" ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "pactl set-sink-volume @DEFAULT_SINK@ -1dB" ];
          };
        };
        volumeMute = {
          modifiers = [ ];
          keysym = "XF86AudioMute";
          description = "mute audio";
          allowWhileSessionLocked = true;
          umbriel = {
            enable = true;
            action = lib.mkDefault "spawn";
            args = lib.mkDefault [ "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" ];
          };
        };
        micLower = {
          modifiers = [ "ALT" ];
          keysym = "XF86AudioLowerVolume";
          description = "lower mic volume";
          repeating = true;
          umbriel = {
            enable = true;
            action = lib.mkDefault "spawn";
            args = lib.mkDefault [ "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SOURCE@ 1%-" ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SOURCE@ 1%-" ];
          };
        };
        micRaise = {
          modifiers = [ "ALT" ];
          keysym = "XF86AudioRaiseVolume";
          description = "raise mic volume";
          repeating = true;
          umbriel = {
            enable = true;
            action = lib.mkDefault "spawn";
            args = lib.mkDefault [ "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SOURCE@ 1%+" ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SOURCE@ 1%+" ];
          };
        };
        micMute = {
          modifiers = [ ];
          keysym = "XF86AudioMicMute";
          description = "mute microphone";
          umbriel = {
            enable = true;
            action = lib.mkDefault "spawn";
            args = lib.mkDefault [ "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" ];
          };
        };
        micMuteAlt = {
          modifiers = [ "ALT" ];
          keysym = "XF86AudioMute";
          description = "mute microphone";
          umbriel = {
            enable = true;
            action = lib.mkDefault "spawn";
            args = lib.mkDefault [ "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" ];
          };
        };
      };
    }
  ];
  meta = { };
}
