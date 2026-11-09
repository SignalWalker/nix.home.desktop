{
  osConfig,
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
              toml = pkgs.formats.toml { };
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
              repeating = lib.mkEnableOption "repeat when held";
              allowWhileSessionLocked = lib.mkEnableOption "allow while session is locked";
              allowWhileInhibited = lib.mkEnableOption "allow while shortcuts are inhibited";
              umbriel =
                let
                  umb = config.umbriel;
                in
                {
                  enable = lib.mkEnableOption "umbriel keybind";
                  action = lib.mkOption {
                    type = lib.types.str;
                  };
                  args = lib.mkOption {
                    type = lib.types.uniq (lib.types.listOf lib.types.anything);
                  };
                  keyStr = lib.mkOption {
                    type = lib.types.str;
                    readOnly = true;
                    default = lib.concatStringsSep "+" (config.modifiers ++ [ config.keysym ]);
                  };
                  bindToml = lib.mkOption {
                    type = toml.type;
                    readOnly = true;
                    default =
                      let
                        argsStr = lib.concatMapStringsSep " " toString umb.args;
                      in
                      {
                        action = "${umb.action} ${argsStr}";
                        repeat = config.repeating;
                        allow_when_locked = config.allowWhileSessionLocked;
                        allow_when_inhibited = config.allowWhileInhibited;
                      };
                    # default =
                    #   let
                    #     dispatchArgs = lib.concatMapStringsSep ", " toLua umb.args;
                    #     dispatchCall =
                    #       if hypr.dispatcher ? expr then
                    #         toLua hypr.dispatcher.expr
                    #       else
                    #         "hl.dsp.${hypr.dispatcher.ident}(${dispatchArgs})";
                    #     flags = toLua (lib.filterAttrs (name: val: val != null && val != false) hypr.flags);
                    #   in {
                    #     action = "${umb.action}";
                    #   };
                    #   "hl.bind(${keys}, ${dispatchCall}, ${flags})";
                  };
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
                    non_consuming = lib.mkEnableOption "Key/mouse events will be passed to the active window in addition to triggering the dispatcher.";
                    auto_consuming = lib.mkEnableOption "Key/mouse events will be passed to the active window if the dispatcher doesn’t succeed.";
                    transparent = lib.mkEnableOption "Cannot be shadowed by other binds.";
                    ignore_mods = lib.mkEnableOption "Will ignore modifiers.";
                    dont_inhibit = lib.mkEnableOption "Bypasses the app’s requests to inhibit keybinds.";
                    submap_universal = lib.mkEnableOption "Will be active no matter the submap.";
                    device = lib.mkEnableOption "Allow binds to be set per device.";
                  };
                  dispatcher = lib.mkOption {
                    type = lib.types.coercedTo lib.types.str (ident: { inherit ident; }) (
                      lib.types.attrTag {
                        expr = lib.mkOption {
                          type = lib.types.luaInline;
                        };
                        ident = lib.mkOption {
                          type = lib.types.str;
                        };
                      }
                    );
                  };
                  args = lib.mkOption {
                    type = lib.types.uniq (lib.types.listOf lib.types.anything);
                  };
                  bindCall = lib.mkOption {
                    type = lib.types.str;
                    readOnly = true;
                    default =
                      let
                        modifiers = map (
                          modifier: if (lib.toLower modifier) == "mod3" then "MOD4" else modifier
                        ) config.modifiers;
                        keys = toLua (lib.concatStringsSep " + " (modifiers ++ [ config.keysym ]));
                        dispatchArgs = lib.concatMapStringsSep ", " toLua hypr.args;
                        dispatchCall =
                          if hypr.dispatcher ? expr then
                            toLua hypr.dispatcher.expr
                          else
                            "hl.dsp.${hypr.dispatcher.ident}(${dispatchArgs})";
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
    # TODO :: detect exec without keys
    desktop.keybinds = lib.mkMerge [
      {
        # WINDOW MANAGER
        windowKill = {
          modifiers = [
            "SUPER"
            "SHIFT"
          ];
          keysym = "Q";
          description = "close active window";
          umbriel = {
            enable = true;
            action = lib.mkDefault "window-close";
            args = lib.mkDefault [ ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "window.close";
            args = lib.mkDefault [ { } ];
          };
        };
        windowKillForce = {
          modifiers = [
            "SUPER"
            "SHIFT"
            "CTRL"
          ];
          keysym = "Q";
          description = "kill active window";
          umbriel = {
            enable = true;
            action = lib.mkDefault "window-kill";
            args = lib.mkDefault [ ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "window.kill";
            args = lib.mkDefault [ { } ];
          };
        };
        windowFullscreenToggle = {
          modifiers = [
            "SUPER"
          ];
          keysym = "F";
          description = "toggle active window fullscreen";
          umbriel = {
            enable = true;
            action = lib.mkDefault "window-toggle-fullscreen";
            args = lib.mkDefault [ ];
          };
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
            "SUPER"
            "ALT"
          ];
          keysym = "F";
          description = "toggle active window maximize";
          umbriel = {
            enable = true;
            action = lib.mkDefault "window-toggle-maximize";
            args = lib.mkDefault [ ];
          };
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
        windowPrimarySizeSetHalf = {
          modifiers = [
            "Super"
            "Ctrl"
          ];
          keysym = "Equal";
          description = "set window primary extent to 50%";
          umbriel = {
            enable = true;
            action = lib.mkDefault "window-set-primary-extent";
            args = lib.mkDefault [ 0.5 ];
          };
        };
        windowFloatingToggle = {
          modifiers = [
            "SUPER"
            "SHIFT"
          ];
          keysym = "Space";
          description = "toggle active window floating";
          umbriel = {
            enable = true;
            action = lib.mkDefault "window-toggle-floating";
            args = lib.mkDefault [ ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "window.float";
            args = lib.mkDefault [ { action = "toggle"; } ];
          };
        };
        windowFloatingDisable = {
          modifiers = [
            "SUPER"
            "ALT"
          ];
          keysym = "Space";
          description = "disable active window floating";
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "window.float";
            args = lib.mkDefault [ { action = "disable"; } ];
          };
        };
        windowPinToggle = {
          modifiers = [
            "SUPER"
            "CTRL"
          ];
          keysym = "P";
          description = "toggle active window pin";
          umbriel = {
            enable = true;
            action = lib.mkDefault "window-toggle-pinned";
            args = lib.mkDefault [ ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "window.pin";
            args = lib.mkDefault [ { } ];
          };
        };
        windowCenter = {
          modifiers = [
            "SUPER"
          ];
          keysym = "C";
          description = "center active window";
          umbriel = {
            enable = true;
            action = lib.mkDefault "window-center";
            args = lib.mkDefault [ ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "window.center";
            args = lib.mkDefault [ { } ];
          };
        };
        windowFocusPrevious = {
          modifiers = [
            "SUPER"
          ];
          keysym = "BracketLeft";
          description = "focus previous window";
          repeating = true;
          umbriel = {
            enable = true;
            action = lib.mkDefault "window-focus-previous";
            args = lib.mkDefault [ ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "window.cycle_next";
            args = lib.mkDefault [ { next = false; } ];
          };
        };
        windowFocusNext = {
          modifiers = [
            "SUPER"
          ];
          keysym = "BracketRight";
          description = "focus next window";
          repeating = true;
          umbriel = {
            enable = true;
            action = lib.mkDefault "window-focus-next";
            args = lib.mkDefault [ ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "window.cycle_next";
            args = lib.mkDefault [ { } ];
          };
        };
        workspacePrevious = {
          modifiers = [
            "SUPER"
          ];
          keysym = "O";
          description = "go to previous workspace";
          umbriel = {
            enable = true;
            action = lib.mkDefault "workspace-previous";
            args = lib.mkDefault [ ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "focus";
            args = lib.mkDefault [ { workspace = "previous_per_monitor"; } ];
          };
        };
        layoutCycle = {
          modifiers = [
            "SUPER"
          ];
          keysym = "Tab";
          description = "cycle workspace layout";
          umbriel = {
            enable = true;
            action = lib.mkDefault "workspace-set-layout";
            args = lib.mkDefault [ "toggle" ];
          };
          hypr = {
            enable = true;
            dispatcher = {
              expr = lib.mkLuaInline ''
                function()
                  local layouts     = { "scrolling", "dwindle", "master", "monocle" }
                  local workspace   = hl.get_active_workspace()
                  if hl.get_active_special_workspace() then
                    workspace = hl.get_active_special_workspace()
                  end

                  local next_layout = "dwindle"

                  if not workspace then
                      return
                  end

                  for i = 1, #layouts do
                      if layouts[i] == workspace.tiled_layout then
                          local next_layout_idx = (i % #layouts) + 1
                          next_layout = layouts[next_layout_idx]
                          break
                      end
                  end

                  local workspace_name = nil
                  if workspace.special then
                    workspace_name = tostring(workspace.name)
                  else
                    workspace_name = tostring(workspace.id)
                  end

                  hl.notification.create({
                    text = "Cycling workspace " .. workspace_name .. " to layout " .. next_layout,
                    duration = 1000,
                  })

                  hl.workspace_rule({ workspace = workspace_name, layout = next_layout })
                end
              '';
            };
          };
        };
        # TERMINAL
        terminalOpen = {
          modifiers = [ "SUPER" ];
          keysym = "Return";
          description = "open terminal";
          umbriel = {
            enable = true;
            action = lib.mkDefault "spawn";
            args = lib.mkDefault [ "app2unit -T" ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "app2unit -T" ];
          };
        };
        terminalOpenAlt = {
          modifiers = [
            "SUPER"
            "ALT"
          ];
          keysym = "Return";
          description = "open terminal (directly)";
          umbriel = {
            enable = true;
            action = lib.mkDefault "spawn";
            args = lib.mkDefault [ "alacritty" ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "alacritty" ];
          };
        };
        # EDITOR
        editorOpen =
          {
            modifiers = [ "CTRL" ];
            keysym = "XF86Calculator";
            description = "open editor";
            umbriel = {
              enable = true;
              action = lib.mkDefault "spawn";
              args = lib.mkDefault [ "emacs" ];
            };
            hypr = {
              enable = true;
              dispatcher = lib.mkDefault "exec_raw";
              args = lib.mkDefault [
                "emacs"
              ];
            };
          };
        # HACK :: framework keyboard doesn't have a calculator button; this is the gear button
        editorOpenAlt = {
          modifiers = [ "CTRL" ];
          keysym = "XF86AudioMedia";
          description = "open editor";
          umbriel = {
            enable = true;
            action = lib.mkDefault "spawn";
            args = lib.mkDefault keybinds.editorOpen.umbriel.args;
          };
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
          repeating = true;
          umbriel = {
            enable = true;
            action = lib.mkDefault "spawn";
            args = lib.mkDefault [ "brightnessctl set 2%-" ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "brightnessctl set 2%-" ];
          };
        };
        brightnessUp = {
          modifiers = [ ];
          keysym = "XF86MonBrightnessUp";
          description = "raise brightness";
          repeating = true;
          umbriel = {
            enable = true;
            action = lib.mkDefault "spawn";
            args = lib.mkDefault [ "brightnessctl set +2%" ];
          };
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "brightnessctl set +2%" ];
          };
        };
        brightnessMin = {
          modifiers = [ "CTRL" ];
          keysym = "XF86MonBrightnessDown";
          description = "minimize brightness";
          umbriel = {
            enable = true;
            action = lib.mkDefault "spawn";
            args = lib.mkDefault [ "brightnessctl set 1" ];
          };
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
          umbriel = {
            enable = true;
            action = lib.mkDefault "spawn";
            args = lib.mkDefault [ "brightnessctl set 100%" ];
          };
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
            modifiers = [ "SUPER" ];
            inherit keysym;
            description = "focus workspace ${wsStr}";
            umbriel = {
              enable = true;
              action = lib.mkDefault "workspace-switch";
              args = lib.mkDefault [ ws ];
            };
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
              "SUPER"
              "SHIFT"
            ];
            inherit keysym;
            description = "send active window to workspace ${wsStr}";
            umbriel = {
              enable = true;
              action = lib.mkDefault "window-move-to-workspace";
              args = lib.mkDefault [ ws ];
            };
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
              modifiers = [ "SUPER" ];
              keysym = specs.key;
              description = "focus window ${lowerName}";
              umbriel = {
                enable = true;
                action = lib.mkDefault "window-focus-or-output-${dir}";
                args = lib.mkDefault [ ];
              };
              hypr = {
                enable = true;
                dispatcher = lib.mkDefault "focus";
                args = lib.mkDefault [ { direction = dir; } ];
              };
            };
            "windowMove${specs.name}" = {
              modifiers = [
                "SUPER"
                "SHIFT"
              ];
              keysym = specs.key;
              description = "move active window ${lowerName}";
              umbriel = {
                enable = true;
                action = lib.mkDefault "window-move-or-output-${dir}";
                args = lib.mkDefault [ ];
              };
              hypr = {
                enable = true;
                dispatcher = lib.mkDefault "window.move";
                args = lib.mkDefault [ { direction = dir; } ];
              };
            };
            # "windowShift${specs.name}" = {
            #   modifiers = [
            #     "SUPER"
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
            #     "SUPER"
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
