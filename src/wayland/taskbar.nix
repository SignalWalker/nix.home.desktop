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
      package = pkgs.waybar;
      systemd = {
        enable = false;
        target = "wayland-session.target";
      };
      settings.mainBar = {
        layer = "bottom";
        position = "top";
        height = 0;
        width = 0;
        spacing = 2;
        modules-left = ["sway/workspaces" "sway/mode" "wireplumber" "custom/media"];
        modules-center = ["sway/window"];
        modules-right = ["network" "cpu" "memory" "temperature" "backlight" "battery" "clock" "tray"];
        window = {
          format = "{title}";
          rewrite = {
            "^(.*) — Firefox.*$" = "🌎 $1";
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
        "custom/media" = {
          format = "♪ {}";
          interval = 1;
          exec = ./waybar/get-media.py;
          exec-if = "pgrep playerctld";
          return-type = "json";
        };
        tray = {
          show-passive-items = true;
          spacing = 2;
        };
        network = let
          tooltip = "{ipaddr}/{cidr}➤{gwaddr} ▲{bandwidthUpBytes}▼{bandwidthDownBytes}";
        in {
          format-icons = {
            ethernet = "";
            wifi = "";
            linked = "🖧";
            disconnected = "";
          };
          format = "{icon} {ifname}";
          format-wifi = "{icon} {essid} ({signalStrength}%)";
          format-disconnected = "{icon} ...";
          tooltip-format = tooltip;
          tooltip-format-linked = "Linked";
          tooltip-format-wifi = "{frequency}MHz ${tooltip}";
          tooltip-format-disconnected = "Disconnected";
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
      style = let
        colorset = theme.colors.signal;
        fontSize = 11;
        fonts = (font.bmpsAt fontSize) ++ font.slab ++ font.symbols;
      in ''
        /* colors */
        @import url("file://${colorset.__meta.css.file}");
        @define-color bg-trans alpha(@bg, 0.66);

        /* general */
        /** font **/
        * {
          font-family: ${concatStringsSep ", " (map (f: "\"${f.name}\"") fonts)};
          font-size: ${toString fontSize}px;

          min-height: 0px;
          margin: 0px;
          padding: 0px;
          border-radius: 0;

          color: @fg;
        }
        tooltip {
          background-color: @bg-trans;
          border: 1px solid @border;
        }
        window#waybar {
          background-color: transparent;
        }
        /* modules */
        box.horizontal > widget > label,
        box.horizontal > widget > box {
          background-color: @bg-trans;
          color: @fg;
          border: 1px solid @border;
          padding: 0px 3px;
          margin: 0px 1px 1px 1px;
        }
        /* workspaces */
        #workspaces {
          padding: 0px 0px;
        }

        #workspaces button {
            padding: 0px 0px;
            background-color: transparent;
            color: @fg;
            /* Use box-shadow instead of border so the text isn't offset */
            box-shadow: inset 0 -3px transparent;
            /* Avoid rounded borders under each workspace name */
            border: none;
            border-radius: 0;
        }

        #workspaces button.focused,
        #workspaces button.active {
          background-color: @bg-focused;
          color: @fg-special;
        }
        #workspaces button.urgent {
          color: @urgent;
        }
      '';
    };
  };
}
