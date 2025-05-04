{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  std = pkgs.lib;
  launcher = config.desktop.launcher;
  ntf = config.desktop.notifications.commands;
  scratchpads = config.desktop.scratchpads;
  hypr = config.wayland.windowManager.hyprland;
  pypr = hypr.pyprland;
  toml = pkgs.formats.toml { };
in
{
  options = with lib; {
    wayland.windowManager.hyprland = {
      pyprland = {
        enable = (mkEnableOption "pyprland") // {
          default = true;
        };
        package = mkPackageOption pkgs "pyprland" { };
        settings = mkOption {
          type = toml.type;
          default = { };
        };
      };
    };
  };
  disabledModules = [ ];
  imports = [ ];
  config = lib.mkMerge [
    {
      home.packages = with pkgs; [
        playerctl
      ];
      home.pointerCursor.hyprcursor = {
        enable = true;
      };
      # services.hyprsunset = {
      #   enable = true;
      #   transitions = {
      #     sunrise = {
      #       calendar = "*-*-* 06:00:00";
      #       requests = [
      #         [
      #           "temperature"
      #           "6500"
      #         ]
      #       ];
      #     };
      #     sunset = {
      #       calendar = "*-*-* 19:00:00";
      #       requests = [
      #         [
      #           "temperature"
      #           "3500"
      #         ]
      #       ];
      #     };
      #   };
      # };
      wayland.windowManager.hyprland = {
        enable = true;
        package = null; # FIX :: this only works if we're also using the nixos module
        portalPackage = null; # FIX :: this only works if we're also using the nixos module
        plugins = (
          with pkgs.hyprlandPlugins;
          [
            # hypr-dynamic-cursors
          ]
        );
        systemd = {
          enable = !(osConfig.programs.hyprland.withUWSM or false);
          enableXdgAutostart = false; # TODO :: Is this necessary with USWM?
        };
        settings = {
          debug = {
            disable_logs = false;
            enable_stdout_logs = false;
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
            enabled = false;
            first_launch_animation = false;
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
            disable_splash_rendering = true;
            disable_hyprland_logo = true;
            enable_anr_dialog = false;
          };
          binds = {
            workspace_back_and_forth = false; # switch to previous workspace when trying to switch to current workspace
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

          plugin = {
            "dynamic-cursors" = {
              enabled = true;
              mode = "tilt";
              shake = {
                enabled = true;
                nearest = true;
                effects = true;
              };
            };
          };
          ecosystem = {
            no_donation_nag = true;
          };
          monitor = [
            ",preferred,auto,1"
          ];
          bind =
            [
              "MOD3,Return,execr,uwsm-app -T"

              "MOD3SHIFT,Q,killactive"
              "MOD3SHIFTCTRL,Q,forcekillactive"

              "MOD3,D,execr,uwsm-app ${launcher.drun}"
              "MOD3ALT,D,execr,uwsm-app ${launcher.run}"

              "MOD3SHIFT,Space,togglefloating,active"

              "MOD3,F,fullscreen,0"
              "MOD3ALT,F,fullscreen,1"

              "MOD3CTRL,P,pin,active"

              "MOD3,O,workspace,previous"

              "MOD3,BracketRight,cyclenext"
              "MOD3,BracketLeft,cyclenext,prev"

              ",Print,execr,${config.desktop.wayland.screenshotScript} active"
              "CTRL,Print,execr,${config.desktop.wayland.screenshotScript} area"
              "MOD3,Print,execr,${config.desktop.wayland.screenshotScript} output"
              "MOD3ALT,Print,execr,${config.desktop.wayland.screenshotScript} screen"

              "MOD3,N,execr,${ntf.restore}"
              "MOD3ALT,N,execr,${ntf.dismiss}"
              "MOD3CTRL,N,execr,${ntf.context}"

              "MOD3ALT,W,execr,${config.desktop.wayland.wallpaper.randomizeCmd}"
              "MOD3ALT,L,execr,swaylock --effect-scale 0.5 --effect-blur 5x3"

              ",XF86MonBrightnessUp,execr,light -A 2"
              ",XF86MonBrightnessDown,execr,light -U 2"
              "CTRL,XF86MonBrightnessUp,execr,light -S 100"
              "CTRL,XF86MonBrightnessDown,execr,light -S 1"

              ",XF86AudioRaiseVolume,execr,pactl set-sink-volume @DEFAULT_SINK@ +1dB" # using pactl isntead of wpctl because it accepts dB, which preserves L/R balance ratio
              ",XF86AudioLowerVolume,execr,pactl set-sink-volume @DEFAULT_SINK@ -1dB"
              ",XF86AudioMute,execr,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              "ALT,XF86AudioRaiseVolume,execr,wpctl set-volume -L 1.0 @DEFAULT_AUDIO_SOURCE@ 0.02+"
              "ALT,XF86AudioLowerVolume,execr,wpctl set-volume -L 1.0 @DEFAULT_AUDIO_SOURCE@ 0.02-"
              ",XF86AudioMicMute,execr,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
              "ALT,XF86AudioMute,execr,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

              ",XF86AudioPrev, execr, playerctl -s previous"
              ",XF86AudioPlay, execr, playerctl -s play-pause"
              ",XF86AudioNext, execr, playerctl -s next"

              "CTRL,XF86Calculator,execr,uwsm-app -T nvim"
              # HACK :: framework keyboard doesn't have a calculator button; this is the gear button
              "CTRL,XF86AudioMedia,execr,uwsm-app -T nvim"
            ]
            ++ (
              let
                dirMap = {
                  "u" = "K";
                  "d" = "J";
                  "l" = "H";
                  "r" = "L";
                };
              in
              (foldl' (
                acc: dir:
                let
                  key = dirMap.${dir};
                in
                acc
                ++ [
                  "MOD3,${key},movefocus,${dir}"
                  "MOD3 SHIFT,${key},movewindow,${dir}"
                ]
              ) [ ] (attrNames dirMap))
            )
            ++ (foldl' (
              acc: space:
              let
                key = toString (space - 1);
              in
              acc
              ++ [
                "MOD3,${key},workspace,${key}"
                "MOD3SHIFT,${key},movetoworkspacesilent,${key}"
              ]
            ) [ ] (genList (i: i + 1) 10));
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
          scratchpads = foldl' (
            acc: pad:
            let
            in
            (
              acc
              // {
                "${pad.name}" = {
                  command = "uwsm-app -a '${pad.name}' -- ${pad.startup}";
                  class = lib.mkIf (pad.hypr.class != null) pad.hypr.class;
                  size = lib.mkIf (
                    pad.resize != null
                  ) "${toString (elemAt pad.resize 0)}% ${toString (elemAt pad.resize 1)}%";
                  unfocus = lib.mkIf (pad.hypr.unfocus != "") pad.hypr.unfocus;
                  excludes = lib.mkIf (pad.hypr.excludes != [ ]) pad.hypr.excludes;
                  match_by = lib.mkIf (pad.hypr.match_by != null) pad.hypr.match_by;
                  inherit (pad.hypr)
                    animation
                    multi
                    pinned
                    restore_excluded
                    hysteresis
                    lazy
                    process_tracking
                    ;
                };
              }
            )
          ) { } (attrValues scratchpads);
        };
        settings = {
          "exec-once" = [
            "uwsm-app -s b ${pypr.package}/bin/pypr"
          ];
          bind = (
            foldl'
              (
                acc: pad:
                let
                  isMod =
                    key:
                    let
                      k = std.toLower key;
                    in
                    k == "shift" || k == "ctrl" || k == "alt";
                  keys = std.splitString "+" (std.trim pad.kb);
                  mods = (if pad.useMod then [ "MOD3" ] else [ ]) ++ (map (std.toUpper) (filter isMod keys));
                  keyStr = std.concatStringsSep " " (filter (key: !(isMod key)) keys);
                  modStr = std.concatStringsSep " " mods;
                  keybind = "${modStr},${keyStr}";
                in
                (
                  acc
                  ++ [
                    "${keybind},execr,pypr toggle ${pad.name}"
                  ]
                )
              )
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
  meta = { };
}
