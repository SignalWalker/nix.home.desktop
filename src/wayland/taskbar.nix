{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.wayland;
in {
  options.signal.desktop.wayland.taskbar = with lib; {
    enable = mkEnableOption "task/status bar";
  };
  imports = [];
  config = lib.mkIf (cfg.enable && cfg.taskbar.enable) {
    signal.desktop.wayland.startupCommands = "waybar &";
    programs.waybar = {
      enable = cfg.taskbar.enable;
      package = pkgs.waybar.override {
        withMediaPlayer = true;
      };
      systemd = {
        enable = false; # config.wayland.windowManager.hyprland.systemdIntegration;
      };
      style = ./waybar/style.css;
      settings.mainBar = {
        layer = "bottom";
        position = "top";
        height = 30;
        # width = 1920;
        spacing = 4;
        modules-left = ["sway/workspaces" "sway/mode" "custom/media"];
        modules-center = ["sway/window"];
        modules-right = ["mpd" "idle_inhibitor" "pulseaudio" "network" "cpu" "memory" "temperature" "backlight" "keyboard-state" "sway/language" "battery" "clock" "tray"];
        keyboard-state = {
          numlock = true;
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };
        mpd = {
          format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
          format-disconnected = "Disconnected ";
          format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
          unknown-tag = "N/A";
          interval = "2";
          consume-icons = {
            on = " ";
          };
          random-icons = {
            off = "<span color=\"#f53c3c\"></span> ";
            on = " ";
          };
          repeat-icons = {
            on = " ";
          };
          single-icons = {
            on = "1 ";
          };
          state-icons = {
            paused = "";
            playing = "";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
        };
      };
    };
  };
}
