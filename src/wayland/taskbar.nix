{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.wayland;
  theme = config.signal.desktop.theme;
  font = theme.font;
in {
  options.signal.desktop.wayland.taskbar = with lib; {
    enable = mkEnableOption "task/status bar";
  };
  imports = [];
  config = lib.mkIf (cfg.enable && cfg.taskbar.enable) {
    # signal.desktop.wayland.startupCommands = "waybar &";
    programs.waybar = {
      enable = cfg.taskbar.enable;
      package = pkgs.waybar.override {
        withMediaPlayer = true;
      };
      systemd = {
        enable = cfg.taskbar.enable; # config.wayland.windowManager.hyprland.systemdIntegration;
        target = "wayland-session.target";
      };
      settings.mainBar = {
        layer = "bottom";
        position = "top";
        height = 30;
        # width = 1920;
        spacing = 4;
        modules-left = ["sway/workspaces" "sway/mode" "pulseaudio" "mpd" "custom/media"];
        modules-center = ["sway/window"];
        modules-right = ["network" "cpu" "memory" "temperature" "backlight" "battery" "clock" "tray"];
        window = {
          format = "{title}";
          rewrite = {
            "(.*) — Firefox Nightly" = "🌎 $1";
          };
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-discharging = "{icon} {power}W {capacity}%";
          format-icons = ["" "" "" "" ""];
        };
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
      style = ''
        /* general */
        * {
          font-family: ${concatStringsSep ", " (map (f: "\"${f.family}\"") (font.slab ++ font.symbols))};
          font-size: 11px;
        }
        window#waybar {
          background-color: rgba(25, 25, 25, 0.75);
          color: #ffffff;
        }
        /* modules */
        #mode, #battery, #pulseaudio, #mpd, #media, #network, #cpu, #memory, #temperature, #backlight, #battery, #clock, #tray {
          padding: 0px 2px;
          margin: 0px;
        }
        /* workspaces */
        #workspaces button {
            padding: 0 5px;
            background-color: transparent;
            color: #ffffff;
            /* Use box-shadow instead of border so the text isn't offset */
            box-shadow: inset 0 -3px transparent;
            /* Avoid rounded borders under each workspace name */
            border: none;
            border-radius: 0;
        }
        #workspaces button.focused {
            box-shadow: inset 0 -3px #ffffff;
        }
        #workspaces button.urgent {
            background-color: #eb4d4b;
        }
      '';
    };
  };
}
