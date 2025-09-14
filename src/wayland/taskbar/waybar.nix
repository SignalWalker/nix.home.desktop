{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  std = pkgs.lib;

  taskbar = config.services.taskbar;
  waybar = config.programs.waybar;

  theme = config.desktop.theme;
in
{
  options = with lib; { };
  disabledModules = [ ];
  imports = [ ];
  config = lib.mkIf (taskbar.enable && (taskbar.type == "waybar")) {
    systemd.user.services.${taskbar.systemd.serviceName} = lib.mkIf waybar.enable {
      Service = {
        Environment =
          let
            path = std.concatStringsSep ":" (
              [ "/run/current-system/sw/bin" ]
              ++ (lib.makeBinPath (
                with pkgs;
                [
                  python311
                  playerctl
                  cava
                ]
              ))
            );
          in
          [
            "PATH=${path}"
          ];
        ExecStart = "${config.programs.waybar.package}/bin/waybar";
        ExecReload = "kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        KillMode = "mixed";
      };
    };

    programs.waybar = {
      enable = false;
      package = pkgs.waybar;
      systemd = {
        enable = false;
        target = config.wayland.systemd.target;
      };
      settings.mainBar = {
        layer = "bottom";
        position = "top";
        height = 0;
        width = 0;
        spacing = 2;
        modules-left = [
          "sway/workspaces"
          "sway/mode"
          "backlight"
          "wireplumber"
          "tray"
          "mpris"
          # "custom/media"
          # "cava"
        ];
        modules-center = [
          "sway/window"
        ];
        modules-right = [
          "network"
          "temperature"
          "memory"
          "cpu"
          "battery"
          "clock"
        ];
        "sway/window" = {
          format = "{title}";
          # icon = true;
          rewrite = {
            "^(.*) — Firefox.*$" = " $1";
            "^(.*) - Kitty$" = " $1";
          };
          max-length = 32;
        };
        wireplumber = {
          format = " {volume}%";
          format-muted = "";
        };
        cpu = {
          format = " {usage}%";
        };
        memory = {
          format = " {percentage}%";
        };
        temperature = {
          format = "{icon} {temperatureC}°C";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        clock = {
          format = " {:%H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
          };
        };
        backlight = {
          format = "{icon} {percent}%";
          format-icons = [
            ""
            ""
            ""
          ];
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = " {capacity}%";
          format-discharging = "{icon} {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          tooltip-format = "{timeTo}";
          tooltip-format-discharging = "{power}W {timeTo}";
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
          exec =
            let
              py = pkgs.python311.withPackages (ps: with ps; [ ]);
            in
            "${py}/bin/python3 ${./waybar/get-media.py}";
          exec-if = "pgrep playerctld";
          return-type = "json";
        };
        mpris = {
          format = "{player_icon}{dynamic}";
          format-paused = "{status_icon}{dynamic}";
          player-icons = {
            "default" = "♪";
            "firefox" = "";
          };
          status-icons = {
            "paused" = "⏸";
          };
        };
        tray = {
          show-passive-items = true;
          spacing = 2;
        };
        network =
          let
            tooltip = "{ipaddr}/{cidr}➤{gwaddr} ▲{bandwidthUpBytes}▼{bandwidthDownBytes}";
          in
          {
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
        cava = {
          cava_config = "${config.xdg.configHome}/cava/config";
          format-icons = [
            "▁"
            "▂"
            "▃"
            "▄"
            "▅"
            "▆"
            "▇"
            "█"
          ];
          bars = 6;
          input_delay = 4;
          bar_delimiter = 0;
        };
      };
      style =
        let
          colorset = theme.colors.signal;
          bgAlpha = toString 0.88;
        in
        ''
          /* colors */
          @import url("file://${colorset.__meta.css.file}");
          @define-color bg-trans alpha(@bg, ${bgAlpha});
          @define-color bg-focused-trans alpha(@bg-focused, ${bgAlpha});

          /* general */
          * {

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
            margin: 1px 0px 1px 0px;
          }
          /* modules */
          box.horizontal > widget > label,
          box.horizontal > widget > box {
            background-color: @bg-trans;
            color: @fg;
            border: 1px solid @border;
            padding: 0px 3px;
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
            background-color: @bg-focused-trans;
            color: @fg-special;
          }
          #workspaces button.urgent {
            color: @urgent;
          }
          #workspaces button.hover {
            background-color: @bg-focused-trans;
            border: none;
            box-shadow: inherit;
            text-shadow: inherit;
          }
        '';
    };
  };
  meta = { };
}
