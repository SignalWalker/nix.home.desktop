{
  config,
  pkgs,
  lib,
  ...
}:
let
  keybind = lib.types.submoduleWith {
    modules = [
      (
        {
          config,
          lib,
          name ? "",
          ...
        }:
        {
          options =
            let
              toLua = lib.generators.toLua { };
              inherit (lib) mkLuaInline;
            in
            {
              modifiers = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
              };
              keysym = lib.mkOption {
                type = lib.types.str;
              };
              description = lib.mkOption {
                type = lib.types.str;
                default = name;
              };
              hypr =
                let
                  hypr = config.hypr;
                in
                {
                  enable = lib.mkEnableOption "hyprland keybind";
                  flags = {
                    description = lib.mkOption {
                      type = lib.types.str;
                      readOnly = true;
                      default = config.description;
                    };
                    locked = lib.mkEnableOption "use while screen locked";
                    release = lib.mkEnableOption "will trigger on release of a key";
                    click = lib.mkEnableOption "Will trigger on release of a key or button as long as the mouse cursor stays inside binds:drag_threshold";
                    drag = lib.mkEnableOption "Will trigger on release of a key or button as long as the mouse cursor moves outside binds:drag_threshold.";
                    long_press = lib.mkEnableOption "Will trigger on long press of a key.";
                    repeating = lib.mkEnableOption "Will repeat when held.";
                    non_consuming = lib.mkEnableOption "Key/mouse events will be passed to the active window in addition to triggering the dispatcher.";
                    auto_consuming = lib.mkEnableOption "Key/mouse events will be passed to the active window if the dispatcher doesn’t succeed.";
                    transparent = lib.mkEnableOption "Cannot be shadowed by other binds.";
                    ignore_mods = lib.mkEnableOption "Will ignore modifiers.";
                    dont_inhibit = lib.mkEnableOption "Bypasses the app’s requests to inhibit keybinds.";
                    submap_universal = lib.mkEnableOption "Will be active no matter the submap.";
                    device = lib.mkEnableOption "Allow binds to be set per device.";
                  };
                  dispatcher = lib.mkOption {
                    type = lib.types.addCheck lib.types.str (dsp: dsp != "execr" && dsp != "exec");
                  };
                  args = lib.mkOption {
                    type = lib.types.uniq (lib.types.listOf lib.types.anything);
                  };
                  bindCall = lib.mkOption {
                    type = lib.types.str;
                    readOnly = true;
                    default =
                      let
                        keys = toLua (lib.concatStringsSep " + " (config.modifiers ++ [ config.keysym ]));
                        dispatchArgs = lib.concatMapStringsSep ", " toLua hypr.args;
                        dispatchCall = "hl.dsp.${hypr.dispatcher}(${dispatchArgs})";
                        flags = toLua (lib.filterAttrs (name: val: val != null && val != false) hypr.flags);
                      in
                      "hl.bind(${keys}, ${dispatchCall}, ${flags})";
                  };
                };
            };
          config = {
            # TODO :: check arg count for dispatcher?
            # assertions = [
            #   {
            #     assertion = config.hypr.enable -> config.hypr.dispatcher != "execr";
            #     message = "hypr dispatcher should be exec_raw instead of execr";
            #   }
            #   {
            #     assertion = config.hypr.enable -> config.hypr.dispatcher != "exec";
            #     message = "hypr dispatcher should be exec_cmd instead of exec";
            #   }
            # ];
          };
        }
      )
    ];
  };
  keybinds = config.desktop.keybinds;
in
{
  options = {
    desktop.keybinds = lib.mkOption {
      type = lib.types.attrsOf keybind;
      default = { };
    };
  };
  config = {
    programs.app2unit.enable = true;
    home.packages = [
      pkgs.playerctl
      pkgs.brightnessctl
    ];
    # TODO :: detect collisions
    desktop.keybinds = lib.mkMerge [
      {
        # WINDOW MANAGER
        windowKill = {
          modifiers = [
            "MOD3"
            "SHIFT"
          ];
          keysym = "Q";
          description = "kill active window";
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "window.close";
            args = lib.mkDefault [ { } ];
          };
        };
        windowKillForce = {
          modifiers = [
            "MOD3"
            "SHIFT"
            "CTRL"
          ];
          keysym = "Q";
          description = "force kill active window";
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "window.kill";
            args = lib.mkDefault [ { } ];
          };
        };
        windowFullscreenToggle = {
          modifiers = [
            "MOD3"
          ];
          keysym = "F";
          description = "toggle active window fullscreen";
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "window.fullscreen";
            args = lib.mkDefault [
              {
                mode = "fullscreen";
                action = "toggle";
              }
            ];
          };
        };
        windowMaximizeToggle = {
          modifiers = [
            "MOD3"
            "ALT"
          ];
          keysym = "F";
          description = "toggle active window maximize";
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "window.fullscreen";
            args = lib.mkDefault [
              {
                mode = "maximized";
                action = "toggle";
              }
            ];
          };
        };
        windowFloatingToggle = {
          modifiers = [
            "MOD3"
            "SHIFT"
          ];
          keysym = "Space";
          description = "toggle active window floating";
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "window.float";
            args = lib.mkDefault [ { action = "toggle"; } ];
          };
        };
        windowPinToggle = {
          modifiers = [
            "MOD3"
            "CTRL"
          ];
          keysym = "P";
          description = "toggle active window pin";
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "window.pin";
            args = lib.mkDefault [ { } ];
          };
        };
        windowCenter = {
          modifiers = [
            "MOD3"
          ];
          keysym = "C";
          description = "center active window";
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "window.center";
            args = lib.mkDefault [ { } ];
          };
        };
        windowFocusPrevious = {
          modifiers = [
            "MOD3"
          ];
          keysym = "BracketLeft";
          description = "focus previous window";
          hypr = {
            enable = true;
            flags = {
              repeating = true;
            };
            dispatcher = lib.mkDefault "window.cycle_next";
            args = lib.mkDefault [ { next = false; } ];
          };
        };
        windowFocusNext = {
          modifiers = [
            "MOD3"
          ];
          keysym = "BracketRight";
          description = "focus next window";
          hypr = {
            enable = true;
            flags = {
              repeating = true;
            };
            dispatcher = lib.mkDefault "window.cycle_next";
            args = lib.mkDefault [ { } ];
          };
        };
        workspacePrevious = {
          modifiers = [
            "MOD3"
          ];
          keysym = "O";
          description = "go to previous workspace";
          hypr = {
            enable = true;
            flags = {
              repeating = true;
            };
            dispatcher = lib.mkDefault "focus";
            args = lib.mkDefault [ { workspace = "previous_per_monitor"; } ];
          };
        };
        # TERMINAL
        terminalOpen = {
          modifiers = [ "MOD3" ];
          keysym = "Return";
          description = "open terminal";
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "app2unit -T" ];
          };
        };
        terminalOpenAlt = {
          modifiers = [
            "MOD3"
            "ALT"
          ];
          keysym = "Return";
          description = "open terminal (directly)";
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "kitty" ];
          };
        };
        # EDITOR
        editorOpen = {
          modifiers = [ "CTRL" ];
          keysym = "XF86Calculator";
          description = "open editor";
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [
              "app2unit -T --app-id=Neovim -- ${config.systemd.user.sessionVariables.EDITOR}"
            ];
          };
        };
        # HACK :: framework keyboard doesn't have a calculator button; this is the gear button
        editorOpenAlt = {
          modifiers = [ "CTRL" ];
          keysym = "XF86AudioMedia";
          description = "open editor";
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault keybinds.editorOpen.hypr.args;
          };
        };
        # BRIGHTNESS
        brightnessDown = {
          modifiers = [ ];
          keysym = "XF86MonBrightnessDown";
          description = "lower brightness";
          hypr = {
            enable = true;
            flags = {
              repeating = true;
            };
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "brightnessctl set 2%-" ];
          };
        };
        brightnessUp = {
          modifiers = [ ];
          keysym = "XF86MonBrightnessUp";
          description = "raise brightness";
          hypr = {
            enable = true;
            flags = {
              repeating = true;
            };
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "brightnessctl set +2%" ];
          };
        };
        brightnessMin = {
          modifiers = [ "CTRL" ];
          keysym = "XF86MonBrightnessDown";
          description = "minimize brightness";
          hypr = {
            enable = true;
            flags = {
              locked = true;
            };
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "brightnessctl set 1" ];
          };
        };
        brightnessMax = {
          modifiers = [ "CTRL" ];
          keysym = "XF86MonBrightnessUp";
          description = "maximize brightness";
          hypr = {
            enable = true;
            flags = {
              locked = true;
            };
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "brightnessctl set 100%" ];
          };
        };
      }
      # numeric workspaces
      (lib.foldl' (
        acc: ws:
        let
          wsStr = toString ws;
          keysym = if ws == 10 then "0" else wsStr;
        in
        acc
        // {
          "workspaceFocus_${wsStr}" = {
            modifiers = [ "MOD3" ];
            inherit keysym;
            description = "focus workspace ${wsStr}";
            hypr = {
              enable = true;
              dispatcher = lib.mkDefault "focus";
              args = lib.mkDefault [
                {
                  workspace = ws;
                }
              ];
            };
          };
          "windowSendToWs_${wsStr}" = {
            modifiers = [
              "MOD3"
              "SHIFT"
            ];
            inherit keysym;
            description = "send active window to workspace ${wsStr}";
            hypr = {
              enable = true;
              dispatcher = lib.mkDefault "window.move";
              args = lib.mkDefault [
                {
                  workspace = ws;
                  follow = false;
                }
              ];
            };
          };
        }
      ) { } (lib.lists.range 1 10))
      # directional window management
      (
        let

          dirMap = {
            "up" = {
              name = "Up";
              key = "K";
              move = {
                x = "0%";
                y = "-1%";
              };
              resize = {
                x = "0%";
                y = "-1%";
              };
            };
            "down" = {
              name = "Down";
              key = "J";
              move = {
                x = "0%";
                y = "1%";
              };
              resize = {
                x = "0%";
                y = "1%";
              };
            };
            "left" = {
              name = "Left";
              key = "H";
              move = {
                x = "-1%";
                y = "0%";
              };
              resize = {
                x = "-1%";
                y = "0%";
              };
            };
            "right" = {
              name = "Right";
              key = "L";
              move = {
                x = "1%";
                y = "0%";
              };
              resize = {
                x = "1%";
                y = "0%";
              };
            };
          };
        in
        (lib.foldlAttrs (
          acc: dir: specs:
          let
            lowerName = lib.toLower specs.name;
          in
          acc
          // {
            "windowFocus${specs.name}" = {
              modifiers = [ "MOD3" ];
              keysym = specs.key;
              description = "focus window ${lowerName}";
              hypr = {
                enable = true;
                flags = {
                  repeating = true;
                };
                dispatcher = lib.mkDefault "focus";
                args = lib.mkDefault [ { direction = dir; } ];
              };
            };
            "windowMove${specs.name}" = {
              modifiers = [
                "MOD3"
                "SHIFT"
              ];
              keysym = specs.key;
              description = "move active window ${lowerName}";
              hypr = {
                enable = true;
                flags = {
                  repeating = true;
                };
                dispatcher = lib.mkDefault "window.move";
                args = lib.mkDefault [ { direction = dir; } ];
              };
            };
            # "windowShift${specs.name}" = {
            #   modifiers = [
            #     "MOD3"
            #     "ALT"
            #     "SHIFT"
            #   ];
            #   keysym = specs.key;
            #   description = "shift active window ${lowerName}";
            #   hypr = {
            #     enable = true;
            #     flags = {
            #       repeating = true;
            #     };
            #     dispatcher = lib.mkDefault "window.move";
            #     args = lib.mkDefault [
            #       (
            #         {
            #           relative = true;
            #         }
            #         // specs.move
            #       )
            #     ];
            #   };
            # };
            # "windowResize${specs.name}" = {
            #   modifiers = [
            #     "MOD3"
            #     "CTRL"
            #   ];
            #   keysym = specs.key;
            #   description = "resize active window ${lowerName}";
            #   hypr = {
            #     enable = true;
            #     flags = {
            #       repeating = true;
            #     };
            #     dispatcher = lib.mkDefault "window.resize";
            #     args = lib.mkDefault [
            #       (
            #         {
            #           relative = true;
            #         }
            #         // specs.resize
            #       )
            #     ];
            #   };
            # };
          }
        ) { } dirMap)
      )
    ];
  };
  meta = { };
}
