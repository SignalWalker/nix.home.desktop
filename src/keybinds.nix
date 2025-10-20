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
          options = {
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
                locked = lib.mkEnableOption "use while screen locked";
                repeat = lib.mkEnableOption "repetition";
                dispatcher = lib.mkOption {
                  type = lib.types.str;
                };
                args = lib.mkOption {
                  type = lib.types.uniq (lib.types.listOf lib.types.str);
                };
                bindFlags = lib.mkOption {
                  type = lib.types.str;
                  readOnly = true;
                  # TODO :: more flags
                  default =
                    (lib.optionalString hypr.locked "l")
                    + (lib.optionalString hypr.repeat "e")
                    + (lib.optionalString (config.description != "") "d");
                };
                bindString = lib.mkOption {
                  type = lib.types.str;
                  readOnly = true;
                  default =
                    let
                      args = [
                        (lib.concatStringsSep " " config.modifiers)
                        config.keysym
                      ]
                      ++ (lib.optional (config.description != "") config.description)
                      ++ [
                        hypr.dispatcher
                      ]
                      ++ hypr.args;
                    in
                    lib.concatStringsSep ", " args;
                };
              };
          };
          config = {
            # TODO :: check arg count for dispatcher?
            # assertions = [
            #   {
            #     assertion = lib.allUnique config.modifiers;
            #     message = "keybind modifiers must be unique";
            #   }
            # ];
          };
        }
      )
    ];
  };
in
{
  options = {
    desktop.keybinds = lib.mkOption {
      type = lib.types.attrsOf keybind;
      default = { };
    };
  };
  config = {
    home.packages = [
      pkgs.playerctl
      pkgs.light
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
            dispatcher = lib.mkDefault "killactive";
            args = lib.mkDefault [ ];
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
            dispatcher = lib.mkDefault "forcekillactive";
            args = lib.mkDefault [ ];
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
            dispatcher = lib.mkDefault "fullscreen";
            args = lib.mkDefault [ "0" ];
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
            dispatcher = lib.mkDefault "fullscreen";
            args = lib.mkDefault [ "1" ];
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
            dispatcher = lib.mkDefault "togglefloating";
            args = lib.mkDefault [ "active" ];
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
            dispatcher = lib.mkDefault "pin";
            args = lib.mkDefault [ "active" ];
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
            dispatcher = lib.mkDefault "centerwindow";
            args = lib.mkDefault [ ];
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
            repeat = true;
            dispatcher = lib.mkDefault "cyclenext";
            args = lib.mkDefault [ "prev" ];
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
            repeat = true;
            dispatcher = lib.mkDefault "cyclenext";
            args = lib.mkDefault [ ];
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
            repeat = true;
            dispatcher = lib.mkDefault "workspace";
            args = lib.mkDefault [ "previous" ];
          };
        };
        # TERMINAL
        terminalOpen = {
          modifiers = [ "MOD3" ];
          keysym = "Return";
          description = "open terminal";
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "execr";
            args = lib.mkDefault [ "uwsm-app -T" ];
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
            dispatcher = lib.mkDefault "execr";
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
            dispatcher = lib.mkDefault "execr";
            args = lib.mkDefault [ "uwsm-app -T -- ${config.systemd.user.sessionVariables.EDITOR}" ];
          };
        };
        # HACK :: framework keyboard doesn't have a calculator button; this is the gear button
        editorOpenAlt = {
          modifiers = [ "CTRL" ];
          keysym = "XF86AudioMedia";
          description = "open editor";
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "execr";
            args = lib.mkDefault [ "uwsm-app -T -- ${config.systemd.user.sessionVariables.EDITOR}" ];
          };
        };
        # BRIGHTNESS
        brightnessDown = {
          modifiers = [ ];
          keysym = "XF86MonBrightnessDown";
          description = "lower brightness";
          hypr = {
            enable = true;
            repeat = true;
            dispatcher = lib.mkDefault "execr";
            args = lib.mkDefault [ "light -U 2" ];
          };
        };
        brightnessUp = {
          modifiers = [ ];
          keysym = "XF86MonBrightnessUp";
          description = "raise brightness";
          hypr = {
            enable = true;
            repeat = true;
            dispatcher = lib.mkDefault "execr";
            args = lib.mkDefault [ "light -A 2" ];
          };
        };
        brightnessMin = {
          modifiers = [ "CTRL" ];
          keysym = "XF86MonBrightnessDown";
          description = "minimize brightness";
          hypr = {
            enable = true;
            locked = true;
            dispatcher = lib.mkDefault "execr";
            args = lib.mkDefault [ "light -S 1" ];
          };
        };
        brightnessMax = {
          modifiers = [ "CTRL" ];
          keysym = "XF86MonBrightnessUp";
          description = "maximize brightness";
          hypr = {
            enable = true;
            locked = true;
            dispatcher = lib.mkDefault "execr";
            args = lib.mkDefault [ "light -S 100" ];
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
              dispatcher = lib.mkDefault "workspace";
              args = lib.mkDefault [ wsStr ];
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
              dispatcher = lib.mkDefault "movetoworkspacesilent";
              args = lib.mkDefault [ wsStr ];
            };
          };
        }
      ) { } (lib.lists.range 1 10))
      # directional window management
      (
        let

          dirMap = {
            "u" = {
              name = "Up";
              key = "K";
              move = "exact 0% -1%";
              resize = "0% -1%";
            };
            "d" = {
              name = "Down";
              key = "J";
              move = "exact 0% 1%";
              resize = "0% 1%";
            };
            "l" = {
              name = "Left";
              key = "H";
              move = "exact -1% 0%";
              resize = "-1% 0%";
            };
            "r" = {
              name = "Right";
              key = "L";
              move = "exact 1% 0%";
              resize = "1% 0%";
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
                repeat = true;
                dispatcher = lib.mkDefault "movefocus";
                args = lib.mkDefault [ dir ];
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
                repeat = true;
                dispatcher = lib.mkDefault "movewindow";
                args = lib.mkDefault [ dir ];
              };
            };
            "windowShift${specs.name}" = {
              modifiers = [
                "MOD3"
                "ALT"
                "SHIFT"
              ];
              keysym = specs.key;
              description = "shift active window ${lowerName}";
              hypr = {
                enable = true;
                repeat = true;
                dispatcher = lib.mkDefault "movewindowpixel";
                args = lib.mkDefault [
                  specs.move
                  "activewindow"
                ];
              };
            };
            "windowResize${specs.name}" = {
              modifiers = [
                "MOD3"
                "CTRL"
              ];
              keysym = specs.key;
              description = "resize active window ${lowerName}";
              hypr = {
                enable = true;
                repeat = true;
                dispatcher = lib.mkDefault "resizewindowpixel";
                args = lib.mkDefault [
                  specs.resize
                  "activewindow"
                ];
              };
            };
          }
        ) { } dirMap)
      )
    ];
  };
  meta = { };
}
