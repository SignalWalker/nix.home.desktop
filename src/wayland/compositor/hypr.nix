{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
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
        plugins = builtins.attrValues {
          # inherit (pkgs.hyprlandPlugins) ;
        };
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
            layout = "master";
          };
          decoration = {
            rounding = 10;
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
          };
          input = {
            kb_model = "pc104";
            kb_layout = "hypersuper(us)";
            kb_options = "caps:hyper";
            natural_scroll = false; # NOTE :: this is *mouse* only; *not* touchpad
            # focus
            follow_mouse = 0;
            mouse_refocus = false;
            float_switch_override_focus = 0;
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
            vfr = true;
            vrr = 2;
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
          experimental = {
            xx_color_management_v4 = true;
          };
          monitor = [
            ",preferred,auto,1"
          ];
          # TODO :: impl config.desktop.windows
          windowrulev2 = [
            "idleinhibit fullscreen, class:.*"
            "idleinhibit focus, class:scratch_term"

            "float,class:(clipse)"
            "size 622 652,class:(clipse)"
          ];
          # mouse binds
          bindm = [
            "MOD3,mouse:272,movewindow"
            "MOD3CTRL,mouse:272,resizewindow"
            # resize and keep aspect ratio
            "MOD3CTRLALT,mouse:272,resizewindow 1"
          ];
          "exec-once" = [
            "uwsm-app -s b clipse -listen"
          ];
        };
      };
    }
    {
      # desktop.keybinds
      wayland.windowManager.hyprland.settings = lib.foldlAttrs (
        acc: name: kb:
        if !kb.hypr.enable then
          acc
        else
          let
            group = "bind${kb.hypr.bindFlags}";
          in
          acc
          // {
            ${group} = (acc.${group} or [ ]) ++ [ kb.hypr.bindString ];
          }
      ) { } config.desktop.keybinds;
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
        };
      };
    })
  ];
  meta = { };
}
