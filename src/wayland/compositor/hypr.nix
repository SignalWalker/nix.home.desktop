{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  launcher = config.desktop.launcher;
  ntf = config.desktop.notifications.commands;
  scratchpads = config.desktop.scratchpads;
  hypr = config.wayland.windowManager.hyprland;
  pypr = hypr.pyprland;
  toml = pkgs.formats.toml {};
in {
  options = with lib; {
    wayland.windowManager.hyprland = {
      pyprland = {
        enable = (mkEnableOption "pyprland") // {default = true;};
        package = mkPackageOption pkgs "pyprland" {};
        settings = mkOption {
          type = toml.type;
          default = {};
        };
      };
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkMerge [
    {
      wayland.windowManager.hyprland = {
        enable = true;
        package = null; # FIX :: this only works if we're also using the nixos module
        portalPackage = null; # FIX :: this only works if we're also using the nixos module
        systemd = {
          enable = true; # TODO :: Is this necessary with USWM?
          enableXdgAutostart = false; # TODO :: Is this necessary with USWM?
        };
        settings = {
          debug = {
            # disable_logs = false;
            # enable_stdout_logs = true;
          };
          general = {
            border_size = 1;
            gaps_in = 4;
            gaps_out = 4;
            allow_tearing = true; # NOTE :: must also set `immediate` windowrule to enable tearing
          };
          decoration = {
            rounding = 0;
            dim_inactive = false;
            screen_shader = ""; # TODO :: fragment shader lmao
            blur = {
              enabled = false;
            };
            shadow = {
              enabled = false;
              sharp = true;
            };
          };
          animations = {
            enabled = true;
            first_launch_animation = true;
          };
          input = {
            kb_model = "pc104";
            kb_layout = "hypersuper(us)";
            kb_options = "caps:hyper";
            natural_scroll = false; # NOTE :: this is *mouse* only; *not* touchpad
            # focus
            follow_mouse = 0;
            special_fallthrough = true;
            focus_on_close = 0;
            touchpad = {
              disable_while_typing = true;
              natural_scroll = true;
              clickfinger_behavior = true;
              "tap-to-click" = true;
              drag_lock = false;
            };
          };
          misc = {
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;
            force_default_wallpaper = 0;
          };
          binds = {
            workspace_back_and_forth = true; # switch to previous workspace when trying to switch to current workspace
            focus_preferred_method = 1; # 1 = longer edges have priority
            movefocus_cycles_groupfirst = true;
            allow_pin_fullscreen = true;
          };
          xwayland = {
            enabled = true;
            use_nearest_neighbor = true;
            force_zero_scaling = true;
          };
          render = {
            direct_scanout = 2;
          };
          cursor = {
            no_warps = true;
          };
          ecosystem = {
            no_donation_nag = true;
          };
          monitor = [
            ",preferred,auto,1"
          ];
          bind =
            [
              "MOD3,Return,exec,uwsm-app -T"

              "MOD3SHIFT,Q,killactive"
              "MOD3SHIFTCTRL,Q,forcekillactive"

              "MOD3,D,exec,uwsm-app ${launcher.drun}"
              "MOD3ALT,D,exec,uwsm-app ${launcher.run}"

              "MOD3SHIFT,Space,togglefloating,active"

              "MOD3,F,fullscreen,0"
              "MOD3ALT,F,fullscreen,1"

              "MOD3CTRL,P,pin,active"
              ",Print,exec,${config.desktop.wayland.screenshotScript} active"
              "CTRL,Print,exec,${config.desktop.wayland.screenshotScript} area"
              "MOD3,Print,exec,${config.desktop.wayland.screenshotScript} output"
              "MOD3ALT,Print,exec,${config.desktop.wayland.screenshotScript} screen"

              "MOD3,N,exec,${ntf.restore}"
              "MOD3ALT,N,exec,${ntf.dismiss}"
              "MOD3CTRL,N,exec,${ntf.context}"

              "MOD3ALT,W,exec,${config.desktop.wayland.wallpaper.randomizeCmd}"
              "MOD3ALT,L,exec,swaylock --effect-scale 0.5 --effect-blur 5x3"

              ",XF86MonBrightnessUp,exec,light -A 2"
              ",XF86MonBrightnessDown,exec,light -U 2"
              "CTRL,XF86MonBrightnessUp,exec,light -S 100"
              "CTRL,XF86MonBrightnessDown,exec,light -S 1"

              ",XF86AudioRaiseVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ +1dB" # using pactl isntead of wpctl because it accepts dB, which preserves L/R balance ratio
              ",XF86AudioLowerVolume,exec,pactl set-sink-volume @DEFAULT_SINK@ -1dB"
              ",XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              "ALT,XF86AudioRaiseVolume,exec,wpctl set-volume -L 1.0 @DEFAULT_AUDIO_SOURCE@ 0.02+"
              "ALT,XF86AudioLowerVolume,exec,wpctl set-volume -L 1.0 @DEFAULT_AUDIO_SOURCE@ 0.02-"
              ",XF86AudioMicMute,exec,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
              "ALT,XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

              "CTRL,XF86Calculator,exec,uwsm-app -T nvim"
              # HACK :: framework keyboard doesn't have a calculator button; this is the gear button
              "CTRL,XF86AudioMedia,exec,uwsm-app -T nvim"
            ]
            ++ (foldl'
              (acc: space: let
                key = toString (space - 1);
              in
                acc
                ++ [
                  "MOD3,${key},workspace,${key}"
                  "MOD3SHIFT,${key},movetoworkspacesilent,${key}"
                ])
              []
              (genList (i: i + 1) 10));
        };
      };
    }
    (lib.mkIf pypr.enable {
      home.packages = [
        pypr.package
      ];
      xdg.configFile."hypr/pyprland.toml" = {
        source = toml.generate "pyprland.toml" pypr.settings;
      };
      wayland.windowManager.hyprland = {
        pyprland.settings = {
          pyprland = {
            plugins = [
              "scratchpads"
            ];
          };
          scratchpads = foldl' (acc: pad: let
          in (acc
            // {
              "${pad.name}" = {
                command = "uwsm-app -a '${pad.name}' -- ${pad.startup}";
                class = lib.mkIf (pad.hypr.class != null) pad.hypr.class;
                size = lib.mkIf (pad.resize != null) "${toString (elemAt pad.resize 0)}% ${toString (elemAt pad.resize 1)}%";
                unfocus = lib.mkIf (pad.hypr.unfocus != "") pad.hypr.unfocus;
                excludes = lib.mkIf (pad.hypr.excludes != []) pad.hypr.excludes;
                match_by = lib.mkIf (pad.hypr.match_by != null) pad.hypr.match_by;
                inherit
                  (pad.hypr)
                  animation
                  multi
                  pinned
                  restore_excluded
                  hysteresis
                  lazy
                  process_tracking
                  ;
              };
            })) {} (attrValues scratchpads);
        };
        settings = {
          "exec-once" = [
            "uwsm-app -s b ${pypr.package}/bin/pypr"
          ];
          bind = (
            foldl'
            (acc: pad: let
              isMod = key: let k = std.toLower key; in k == "shift" || k == "ctrl" || k == "alt";
              keys = std.splitString "+" (std.trim pad.kb);
              mods =
                (
                  if pad.useMod
                  then ["MOD3"]
                  else []
                )
                ++ (map (std.toUpper) (filter isMod keys));
              keyStr = std.concatStringsSep " " (filter (key: !(isMod key)) keys);
              modStr = std.concatStringsSep " " mods;
              keybind = "${modStr},${keyStr}";
            in (acc
              ++ [
                "${keybind},exec,pypr toggle ${pad.name}"
              ]))
            [
              "MOD3,Minus,togglespecialworkspace,scratchpad"
              "MOD3SHIFT,Minus,movetoworkspacesilent,special:scratchpad"
            ]
            (attrValues scratchpads)
          );
        };
      };
    })
  ];
  meta = {};
}
