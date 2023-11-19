{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  wayland = config.signal.desktop.wayland;
  bar = wayland.taskbar;
  theme = config.signal.desktop.theme;
  font = theme.font;
  fontSize = 11;

  waybar = config.programs.waybar;
  eww = config.programs.eww;
  # ironbar = config.programs.ironbar;
in {
  options = with lib; {
    programs.waybar.src = mkOption {
      type = types.path;
    };
    signal.desktop.wayland.taskbar = {
      enable = mkEnableOption "task/status bar";
    };
  };
  imports = [];
  config = lib.mkIf (wayland.enable && bar.enable) {
    systemd.user.services."wayland-taskbar" = {
      Unit = {
        Description = "Taskbar for Wayland compositors.";
        PartOf = [wayland.systemd.target];
        Before = ["tray.target"];
        BindsTo = ["tray.target"];
      };
      Service =
        if eww.enable
        then {
          Type = "simple";
          Environment = ["PATH=/run/current-system/sw/bin:${pkgs.playerctl}/bin"];
          ExecStart = "${eww.package}/bin/eww daemon --no-daemonize --force-wayland";
        }
        else {
          Environment = ["PATH=/run/current-system/sw/bin:${pkgs.python311}/bin:${pkgs.playerctl}/bin:${pkgs.cava}/bin"];
          ExecStart = "${config.programs.waybar.package}/bin/waybar";
          ExecReload = "kill -SIGUSR2 $MAINPID";
          Restart = "on-failure";
          KillMode = "mixed";
        };
      Install = {
        WantedBy = [wayland.systemd.target];
        RequiredBy = ["tray.target"];
      };
    };
    # programs.ironbar = {
    #   enable = false;
    #   config = {
    #     position = "top";
    #     start = [
    #       {
    #         type = "workspaces";
    #       }
    #       {type = "tray";}
    #       {
    #         type = "music";
    #         player_type = "mpris";
    #       }
    #     ];
    #     center = [
    #       {type = "focused";}
    #     ];
    #     end = [
    #       {type = "clipboard";}
    #       {
    #         type = "upower";
    #         format = "{percentage}%";
    #       }
    #       {type = "clock";}
    #     ];
    #   };
    #   style = "";
    #   systemd = false;
    # };
    programs.eww = {
      enable = false;
      package = pkgs.eww-wayland;
      configDir = ./eww;
    };
    programs.waybar = {
      enable = !eww.enable;
      package = pkgs.waybar;
      systemd = {
        enable = false;
        target = wayland.systemd.target;
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
          # icon-size = fontSize;
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
          format-icons = ["" "" "" "" ""];
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
          format-icons = ["" "" ""];
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = " {capacity}%";
          format-discharging = "{icon} {capacity}%";
          format-icons = ["" "" "" "" ""];
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
          exec = let
            py = pkgs.python311.withPackages (ps: with ps; []);
          in "${py}/bin/python3 ${./waybar/get-media.py}";
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
        cava = {
          cava_config = "${config.xdg.configHome}/cava/config";
          format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          bars = 6;
          input_delay = 4;
          bar_delimiter = 0;
        };
      };
      style = let
        colorset = theme.colors.signal;
        fonts = (font.bmpsAt fontSize) ++ font.slab ++ font.symbols;
        bgAlpha = toString 0.88;
      in ''
        /* colors */
        @import url("file://${colorset.__meta.css.file}");
        @define-color bg-trans alpha(@bg, ${bgAlpha});
        @define-color bg-focused-trans alpha(@bg-focused, ${bgAlpha});

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
}
