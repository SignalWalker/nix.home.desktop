{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (builtins) attrValues;
  scratchpads = config.desktop.scratchpads;
  hypr = config.wayland.windowManager.hyprland;
  hyprPkg = if hypr.package == null then osConfig.programs.hyprland.package else hypr.package;
  pypr = hypr.pyprland;
  toml = pkgs.formats.toml { };
in
{
  options =
    let
      inherit (lib) mkEnableOption mkOption mkPackageOption;
    in
    {
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
  config = lib.mkMerge [
    {
      programs.app2unit = {
        enable = true;
      };
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
      xdg.configFile."hypr/ash" = {
        source = ./hyprland;
      };
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
        configType = "lua";
        extraLuaFiles = {
          "debug" = {
            autoLoad = true;
            content = ''
              hl.on("hyprland.start", function()
                hl.exec_raw("kitty")
              end)
            '';
          };
          "hw.monitors" = {
            autoLoad = true;
            content = ''
              hl.monitor({
                output = "",
                mode = "preferred",
                position = "auto",
                scale = 1
              });
            '';
          };
          "config" = {
            autoLoad = true;
            content = ''
              hl.config({
                general = {
                  border_size = 1,
                  gaps_in = 4,
                  gaps_out = 4, 
                  allow_tearing = true, -- NOTE :: must also set `immediate` windowrule to enable tearing
                  layout = "master"
                },
                decoration = {
                  rounding = 10,
                  dim_inactive = false,
                  blur = {
                    enabled = false
                  },
                  shadow = {
                    enabled = false
                  }
                },
                animations = {
                  enabled = false,
                },
                misc = {
                  mouse_move_enables_dpms = true,
                  key_press_enables_dpms = true,
                  force_default_wallpaper = 0,
                  disable_splash_rendering = true,
                  disable_hyprland_logo = true,
                  enable_anr_dialog = false,
                  vrr = 2,
                },
                binds = {
                  workspace_back_and_forth = false,
                  focus_preferred_method = 1, -- NOTE :: longer edges have priority
                  movefocus_cycles_groupfirst = true,
                  allow_pin_fullscreen = true,
                },
                xwayland = {
                  enabled = true,
                  use_nearest_neighbor = true,
                  force_zero_scaling = true
                },
                render = {
                  direct_scanout = 2,
                },
                cursor = {
                  no_warps = true,
                },
                ecosystem = {
                  no_update_news = true,
                  no_donation_nag = true,
                  enforce_permissions = false, -- TODO :: hyprland permissions
                },
                input = {
                  kb_model = "pc104",
                  kb_layout = "hypersuper(us)",
                  kb_options = "caps:hyper",
                  natural_scroll = false, -- NOTE :: this is *mouse* only; *not* touchpad
                  -- focus
                  follow_mouse = 0,
                  mouse_refocus = false,
                  float_switch_override_focus = 0,
                  special_fallthrough = true,
                  focus_on_close = 0,
                  touchpad = {
                    disable_while_typing = true,
                    natural_scroll = true,
                    clickfinger_behavior = true,
                    tap_to_click = true,
                    drag_lock = false
                  }
                }
              })
            '';
          };
        };
      };
    }
    # desktop.windows
    {
      wayland.windowManager.hyprland.extraLuaFiles."window" = {
        autoLoad = true;
        content = ''
          hl.window_rule({
            name = "float-everything",
            match = {
              initial_class = ".*",
            },
            float = true
          })
          hl.window_rule({
              name  = "suppress-maximize-events",
              match = { class = ".*" },
              suppress_event = "maximize",
          })
          hl.window_rule({
            -- Fix some dragging issues with XWayland
            name  = "fix-xwayland-drags",
            match = {
              class      = "^$",
              title      = "^$",
              xwayland   = true,
              float      = true,
              fullscreen = false,
              pin        = false,
            },
            no_focus = true,
          })
        '';
      };
      # wayland.windowManager.hyprland.settings.windowrule = [
      #   {
      #     name = "float-everything-by-default-because-most-apps-assume-floating-wm";
      #     "match:initial_class" = ".*";
      #     float = true;
      #   }
      #   {
      #     name = "clipse-float-center";
      #     "match:class" = "clipse";
      #     float = true;
      #     size = "(monitor_w*0.33) (monitor_h*0.5)";
      #     center = true;
      #   }
      #   {
      #     name = "float-modal";
      #     "match:modal" = true;
      #     float = true;
      #   }
      #   {
      #     name = "float-wine";
      #     "match:initial_class" = ".*\\\\.exe$";
      #     float = true;
      #   }
      # ]
      # ++ (map
      #   (initial_class: {
      #     name = "dont-float-${initial_class}";
      #     "match:initial_class" = initial_class;
      #     float = false;
      #   })
      #   [
      #     "Neovim"
      #     "org.godotengine.Editor"
      #     "org.duckstation.DuckStation"
      #     "dolphin-emu"
      #   ]
      # );
      # TODO
      # wayland.windowManager.hyprland.settings.extraConfig =
      #   let
      #     toMatch = name: crit: "match:${name} = ${crit}";
      #     toWinRules = win: ''
      #       windowrule {
      #         name = ${win.name}
      #
      #       }
      #     '';
      #   in
      #   lib.concatStringsSep "\n" (map (toWinRules) config.desktop.windows);
    }
    {
      wayland.windowManager.hyprland.extraLuaFiles = {
        "ui.keybinds.mouse" = {
          autoLoad = true;
          content = ''
            hl.bind("MOD3 + mouse:272", hl.dsp.window.drag(), {mouse = true})
            hl.bind("MOD3 + CTRL + mouse:272", hl.dsp.window.resize(), {mouse = true})
            -- # resize and keep aspect ratio
            -- "MOD3CTRLALT,mouse:272,resizewindow 1"
          '';
        };
      }
      // (lib.mapAttrs' (name: kb: {
        name = "ui.keybinds.${name}";
        value = {
          autoLoad = true;
          content = kb.hypr.bindCall;
        };
      }) (lib.filterAttrs (name: val: val.hypr.enable) config.desktop.keybinds));
      # wayland.windowManager.hyprland.extraLuaFiles."ui.keybinds" = {
      #   autoLoad = true;
      #   content = lib.concatMapAttrsStringSep "\n" (name: kb: kb.hypr.bindCall) (
      #     lib.filterAttrs (name: val: val.hypr.enable) config.desktop.keybinds
      #   );
      # };
    }
    (lib.mkIf pypr.enable {
      home.packages = [
        pypr.package
      ];
      xdg.configFile."pypr/config.toml" = {
        source = toml.generate "pyprland.toml" pypr.settings;
      };
      systemd.user.services."pyprland" =
        let
          target = config.wayland.systemd.target;
        in
        {
          Unit = {
            Description = "Pyprland daemon";
            After = [ target ];
            StartLimitIntervalSec = 600;
            StartLimitBurst = 5;
          };
          Service = {
            Type = "simple";
            ExecStart = "${pypr.package}/bin/pypr";
            Restart = "always";
            Slice = "session-graphical.slice"; # provided by UWSM
          };
          Install = {
            WantedBy = [ target ];
          };
        };
      wayland.windowManager.hyprland = {
        pyprland.settings = {
          pyprland = {
            "hyprland_version" = builtins.head (lib.splitString "+" hyprPkg.version);
            plugins = [
              "scratchpads"
            ];
          };
          scratchpads = lib.foldl' (
            acc: pad:
            let
            in
            (
              acc
              // {
                "${pad.name}" = {
                  command = "app2unit -a '${pad.name}' -- ${pad.startup}";
                  class = lib.mkIf (pad.hypr.class != null) pad.hypr.class;
                  size = lib.mkIf (
                    pad.resize != null
                  ) "${toString (lib.elemAt pad.resize 0)}% ${toString (lib.elemAt pad.resize 1)}%";
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
      };
    })
  ];
  meta = { };
}
