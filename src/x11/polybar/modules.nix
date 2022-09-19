{colors, ...}: {
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  scripts = "${config.signal.desktop.polybarScripts}/polybar-scripts";
in
  std.mapAttrs' (module: settings: std.nameValuePair "module/${module}" settings) {
    # system
    cpu = {
      type = "internal/cpu";
      interval = 2;
      format-prefix = "";
      format-prefix-foreground = colors.foreground-alt;
      format-underline = "#f90000";
      label = "%percentage:2%%";
    };
    memory = {
      type = "internal/memory";
      interval = 3;
      format = "<label>";
      format-prefix = "";
      format-prefix-foreground = colors.foreground-alt;
      format-underline = "#4bffdc";
      label = "%mb_used%";
    };
    battery = let
      format-charging-underline = "#ffb52a";
      ramp-capacity = ["" "" ""];
    in {
      type = "internal/battery";
      battery = "BAT0";
      adapter = "ADP0";
      full-at = 98;

      format-charging = "<animation-charging> <label-charging>";
      inherit format-charging-underline;

      format-discharging = "<animation-discharging> <label-discharging>";
      format-discharging-underline = format-charging-underline;

      format-full-prefix = " ";
      format-full-prefix-foreground = colors.foreground-alt;
      format-full-underline = format-charging-underline;

      inherit ramp-capacity;
      ramp-capacity-foreground = colors.foreground-alt;

      animation-charging = ramp-capacity;
      animation-charging-foreground = colors.foreground-alt;
      animation-charging-framerate = 750;

      animation-discharging = std.reverseList ramp-capacity;
      animation-discharging-foreground = colors.foreground-alt;
      animation-discharging-framerate = 750;
    };
    temperature = let
      format-underline = "#f50a4d";
    in {
      type = "internal/temperature";
      thermal-zone = 0;
      warn-temperature = 60;

      format = "<ramp> <label>";
      inherit format-underline;
      format-warn = "<ramp> <label-warn>";
      format-warn-underline = format-underline;

      label = "%temperature-c%";
      label-warn = "%temperature-c%";
      label-warn-foreground = colors.secondary;

      ramp = ["" "" ""];
      ramp-foreground = colors.foreground-alt;
    };
    filesystem = {
      type = "internal/fs";
      interval = 25;

      mount-0 = "/";

      label-mounted = "%{F#0a81f5}%mountpoint%%{F-}: %free% / %total%";
      label-unmounted = "%mountpoint% ∅";
      label-unmounted-foreground = colors.foreground-alt;
    };
    # wm
    xwindow = {
      type = "internal/xwindow";
      label = "%title:0:128:…%";
    };
    ewmh = {
      type = "internal/xworkspaces";
      icon-default = ">";
      format = "<label-state>";
      label-monitor = "%name%";
      label-active = "%name%";
      label-active-foreground = colors.foreground-notice;
      label-occupied = "%name%";
      label-urgent = "%name%";
      label-urgent-foreground = colors.foreground-alert;
      label-empty = "";
      enable-click = false;
      enable-scroll = false;
      # Only show workspaces defined on the same output as the bar
      pin-workspaces = false;
    };
    # network
    wlan-essid = {
      type = "internal/network";
      interface = "wlan0";
      interval = 12.0;

      format-connected = "<label-connected>";
      format-disconnected = "<label-disconnected>";
      format-packetloss = "";

      label-connected = "📶 %essid%";
      label-disconnected = "";
      label-packetloss = "";
    };
    bond-network = {
      type = "internal/network";
      interface = "bond0";
      accumulate-stats = false;
      interval = "1800.0";

      format-connected = "<label-connected>";
      format-disconnected = "<label-disconnected>";
      format-packetloss = "<label-packetloss>";

      label-connected = "🖧 %ifname% %local_ip% %upspeed:3% %downspeed:3%";
      label-disconnected = "🖧 %ifname% ≐";
      label-packetloss = "🖧 %ifname% …";
    };
    # misc
    date = {
      type = "internal/date";
      interval = 5;
      date = "%Y-%m-%d";
      date-alt = "%Y-%m-%d";
      time = "%H:%M";
      time-alt = "%H:%M:%S";
      format-prefix = "";
      format-prefix-foreground = colors.foreground-alt;
      format-underline = "#0a6cf5";
      label = "%date% %time%";
    };
    weather = {
      type = "custom/script";
      exec = "wedder";
      exec-if = "ping openweathermap.org -c 1";
      tail = true;
    };
    # audio
    player-mpris-tail = {
      type = "custom/script";
      exec = "${scripts}/player-mpris-tail/player-mpris-tail.py -f '{icon} {:artist:t48:{artist}:}{:artist: - :}{:t48:{title}:}'";
      tail = true;
    };
    mpd = {
      type = "internal/mpd";
      format-online = "<label-song>  <icon-prev> <icon-stop> <toggle> <icon-next>";
      icon-prev = "";
      icon-stop = "";
      icon-play = "";
      icon-pause = "";
      icon-next = "";
      label-song-maxlen = 25;
      label-song-ellipsis = true;
    };
    pulseaudio = {
      type = "internal/pulseaudio";
      format-volume = "<label-volume> <bar-volume>";
      label-volume = "VOL %percentage%%";
      label-volume-foreground = colors.foreground;
      label-muted = " 🔇 muted";
      label-muted-foreground = "#666";

      bar-volume-width = 10;
      bar-volume-foreground = [
        "#55aa55"
        "#55aa55"
        "#55aa55"
        "#55aa55"
        "#55aa55"
        "#f5a70a"
        "#ff5555"
      ];
      bar-volume-gradient = false;
      bar-volume-indicator = "|";
      bar-volume-indicator-font = 2;
      bar-volume-fill = "─";
      bar-volume-fill-font = 2;
      bar-volume-empty = "─";
      bar-volume-empty-font = 2;
      bar-volume-empty-foreground = colors.foreground-alt;
    };
  }
