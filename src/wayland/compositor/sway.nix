{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  theme = config.desktop.theme;
  wayland = config.desktop.wayland;
  sway_cfg = wayland.compositor.sway;
  scratchpads = config.desktop.scratchpads;
  bar = wayland.taskbar;
  # exports = let
  #   vars = config.desktop.wayland.sessionVariables;
  # in (std.concatStringsSep "\n" (map (key: "export ${key}='${toString vars.${key}}'") (attrNames vars)));
in {
  options = with lib; {
    desktop.wayland.compositor.sway = with lib; {
      enable = mkEnableOption "sway wayland compositor";
    };
  };
  imports = [];
  config = lib.mkIf (wayland.enable && sway_cfg.enable) {
    wayland.windowManager.sway = let
      mod = config.signal.desktop.keyboard.compositor.modifier;
      launcher = config.desktop.launcher;
      up = "k";
      down = "j";
      left = "h";
      right = "l";
    in {
      enable = true;
      # chokes on hypersuper
      checkConfig = false;
      extraConfigEarly = ''
        include ${config.desktop.theme.inputs.i3}
      '';
      config = {
        bars = [];
        assigns = {};
        colors = {
          background = "$base";
          focused = {
            border = "$pink";
            background = "$base";
            text = "$text";
            indicator = "$rosewater";
            childBorder = "$pink";
          };
          focusedInactive = {
            border = "$mauve";
            background = "$mantle";
            text = "$text";
            indicator = "$rosewater";
            childBorder = "$mauve";
          };
          unfocused = {
            border = "$mauve";
            background = "$crust";
            text = "$text";
            indicator = "$rosewater";
            childBorder = "$mauve";
          };
          urgent = {
            border = "$peach";
            background = "$base";
            text = "$peach";
            indicator = "$overlay0";
            childBorder = "$peach";
          };
          placeholder = {
            border = "$overlay0";
            background = "$base";
            text = "$text";
            indicator = "$overlay0";
            childBorder = "$overlay0";
          };
        };
        floating = {
          titlebar = true;
          border = 1;
          criteria = foldl' (acc: window:
            if window.floating
            then acc ++ [window.criteria]
            else acc) []
          config.desktop.windows;
        };
        fonts = let
          fonts = theme.font.slab ++ theme.font.symbols;
        in {
          names = map (font: font.name) fonts;
          size = 10.0;
        };
        gaps = {
          inner = 2;
          outer = 2;
          smartBorders = "on";
          smartGaps = true;
        };
        output = {
          "*" = {
            adaptive_sync = "on";
            scale_filter = "nearest";
            scale = "1";
            # background = "/home/ash/pictures/wallpapers/train_and_lake.png fill #000000";
          };
        };
        seat = {};
        window = {
          border = 1;
          hideEdgeBorders = "smart";
          commands =
            [
              {
                criteria = {
                  "instance" = "Godot_Engine";
                  "title" = ".*DEBUG.*";
                };
                command = "floating enable";
              }
            ]
            ++ (foldl' (acc: pad:
              acc
              ++ (std.optional pad.automove {
                command = "move scratchpad";
                criteria = pad.sway.criteria;
              })) [] (attrValues scratchpads));
        };
        modifier = mod;
        workspaceAutoBackAndForth = true;
        input = {
          "type:touchpad" = {
            tap = "enabled";
            natural_scroll = "enabled";
            accel_profile = "adaptive";
            dwt = "enabled";
          };
          "type:pointer" = {
            accel_profile = "adaptive";
            pointer_accel = "1.0";
          };
          "type:keyboard" = {
            # lib.mkIf (!(osConfig ? services.xserver.extraLayouts.hypersuper)) {
            # set in osCOnfig.services.xserver

            xkb_layout = "hypersuper(us)";
            xkb_options = "caps:hyper";
            xkb_model = "pc104";
            # xkb_capslock = "disabled";
            # xkb_numlock = "enabled";
          };
        };
        focus = {
          followMouse = "no";
          wrapping = "workspace";
          mouseWarping = false;
        };
        inherit up down left right;
        keybindings = let
          dirMap = {
            inherit up down left right;
          };
          ntf = config.desktop.notifications.commands;
        in
          {
            "${mod}+Return" = "exec kitty";
            "${mod}+Shift+q" = "kill";

            "${mod}+d" = "exec '${launcher.drun}'";
            "${mod}+Alt+d" = "exec '${launcher.run}'";

            "${mod}+Ctrl+r" = "reload";
            "${mod}+Ctrl+Alt+Shift+q" = "exec swaymsg exit";

            "${mod}+Shift+space" = "floating toggle";
            "${mod}+space" = "focus mode_toggle";

            "${mod}+s" = "layout stacking";
            "${mod}+Tab" = "layout tabbed";

            "${mod}+f" = "fullscreen";

            "${mod}+w" = "mode split";
            "${mod}+r" = "mode resize";

            "XF86MonBrightnessUp" = "exec light -A 2";
            "XF86MonBrightnessDown" = "exec light -U 2";
            "Ctrl+XF86MonBrightnessUp" = "exec light -S 100";
            "Ctrl+XF86MonBrightnessDown" = "exec light -S 1";
            "${mod}+XF86MonBrightnessUp" = "opacity plus 0.02";
            "${mod}+XF86MonBrightnessDown" = "opacity minus 0.02";
            "${mod}+Ctrl+XF86MonBrightnessUp" = "opacity set 1";

            "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl -s previous";
            "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl -s play-pause";
            "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl -s next";

            "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 0.02+";
            "XF86AudioLowerVolume" = "exec wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 0.02-";
            "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            "Alt+XF86AudioRaiseVolume" = "exec wpctl set-volume -L 1.0 @DEFAULT_AUDIO_SOURCE@ 0.02+";
            "Alt+XF86AudioLowerVolume" = "exec wpctl set-volume -L 1.0 @DEFAULT_AUDIO_SOURCE@ 0.02-";
            "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
            "Alt+XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

            "${mod}+Ctrl+b" = "border toggle";
            "${mod}+Ctrl+p" = "floating enable, sticky toggle";

            "Print" = "exec ${config.desktop.wayland.screenshotScript} active";
            "Ctrl+Print" = "exec ${config.desktop.wayland.screenshotScript} area";
            "${mod}+Ctrl+F12" = "exec ${config.desktop.wayland.screenshotScript} area";
            "${mod}+Print" = "exec ${config.desktop.wayland.screenshotScript} output";
            "${mod}+Alt+Print" = "exec ${config.desktop.wayland.screenshotScript} screen";

            "${mod}+n" = "exec ${ntf.restore}";
            "${mod}+Alt+n" = "exec ${ntf.dismiss}";
            "${mod}+Ctrl+n" = "exec ${ntf.context}";

            "${mod}+Alt+w" = "exec ${config.desktop.wayland.wallpaper.randomizeCmd}";

            "${mod}+Alt+l" = "exec swaylock --effect-scale 0.5 --effect-blur 5x3";

            "${mod}+XF86HomePage" = "mode passthrough";
          }
          // (foldl'
            (acc: dir: let
              key = dirMap.${dir};
            in
              acc
              // {
                "${mod}+${key}" = "focus ${dir}";
                "${mod}+Shift+${key}" = "move ${dir}";
              })
            {}
            (attrNames dirMap))
          // (foldl'
            (acc: space: let
              key = toString (space - 1);
            in
              acc
              // {
                "${mod}+${key}" = "workspace number ${key}";
                "${mod}+Shift+${key}" = "move container to workspace number ${key}";
              })
            {}
            (genList (i: i + 1) 10))
          // (
            foldl'
            (acc: pad: let
              keybind =
                if pad.useMod
                then "${mod}+${pad.kb}"
                else "${pad.kb}";
            in (acc
              // {
                "${keybind}" = pad.sway.show;
              }
              // (
                if pad.exec != null
                then {
                  "Ctrl+${keybind}" = "exec '${pad.exec}'";
                }
                else {}
              )))
            {
              "${mod}+Minus" = "scratchpad show";
              "${mod}+Shift+Minus" = "move scratchpad";
            }
            (attrValues scratchpads)
          );
        modes = {
          "split" = {
            "${mod}+s" = "splitv; mode default";
            "${mod}+v" = "splith; mode default";
            "Escape" = "mode default";
          };
          "resize" = {
            "${mod}+${left}" = "resize shrink width 10px";
            "${mod}+${right}" = "resize grow width 10px";
            "${mod}+${up}" = "resize shrink height 10px";
            "${mod}+${down}" = "resize grow height 10px";

            "${mod}+c" = "resize set width 50 ppt height 50 ppt, move position center; mode default";
            "${mod}+Ctrl+c" = "resize set width 75 ppt height 75 ppt, move position center; mode default";
            "${mod}+Shift+c" = "resize set width 83 ppt height 83 ppt, move position center; mode default";

            "Escape" = "mode default";
            "Return" = "mode default";
          };
          "passthrough" = {
            "${mod}+XF86HomePage" = "mode default";
          };
        };
        terminal = "kitty";
        menu = launcher.drun;
        defaultWorkspace = "workspace number 1";
        startup =
          [
            # {command = "${config.desktop.wayland.__systemdStartupScript}";}
          ]
          ++ (foldl' (acc: scratch:
            if scratch.autostart
            then acc ++ [{command = "'${scratch.exec}'";}]
            else acc) [] (attrValues scratchpads));
      };
      swaynag = {
        enable = true;
        settings = {};
      };
      systemd = {
        enable = true;
        variables = lib.mkOptionDefault [
          "PATH"
        ];
      };
      extraConfig = ''
        bindswitch --reload --locked {
          lid:on output eDP-1 dpms off
          lid:off output eDP-1 dpms on
        }
        inhibit_idle fullscreen
      '';
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
      xwayland = config.desktop.wayland.xwayland.enable;
    };
    systemd.user.targets."sway-session" = {
      Unit = {
        Wants = [wayland.systemd.target];
        Before = [wayland.systemd.target];
      };
    };
  };
}
