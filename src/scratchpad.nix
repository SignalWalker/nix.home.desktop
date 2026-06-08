{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (builtins)
    mapAttrs
    elemAt
    attrNames
    filter
    ;
  scratchpad = lib.types.submoduleWith {
    modules = [
      (
        {
          config,
          lib,
          name,
          ...
        }:
        {
          options =
            let
              inherit (lib) mkOption types mkEnableOption;
            in
            {
              kb = mkOption {
                type = types.str;
                default = name;
              };
              useMod = (mkEnableOption "modifier key in keybind") // {
                default = true;
              };
              criteria = mkOption {
                type = types.attrsOf (
                  types.oneOf [
                    types.bool
                    types.int
                    types.str
                  ]
                );
                default = { };
              };
              criteriaStr = mkOption {
                type = types.attrsOf types.str;
                readOnly = true;
                default = mapAttrs (key: val: if val == false then "false" else toString val) config.criteria;
              };
              exec = mkOption {
                type = types.nullOr types.str;
                readOnly = true;
                default =
                  if config.startup == null then
                    null
                  else if config.systemdCat then
                    "systemd-cat --identifier=${config.name} ${config.startup}"
                  else
                    config.startup;
              };
              sway = {
                resize = mkOption {
                  type = types.nullOr types.str;
                  readOnly = true;
                  default =
                    let
                      dimsToStr = dims: "width ${toString (elemAt dims 0)} ppt height ${toString (elemAt dims 1)} ppt";
                    in
                    (if config.resize == null then null else (dimsToStr config.resize));
                };
                show = mkOption {
                  type = types.str;
                  readOnly = true;
                  default =
                    let
                      criteria = lib.concatStringsSep " " (
                        map (key: "${key}=\"${config.criteriaStr.${key}}\"") (attrNames config.criteriaStr)
                      );
                    in
                    "[${criteria}] scratchpad show"
                    + (lib.optionalString (config.sway.resize != null) ", resize set ${config.sway.resize}")
                    + (lib.optionalString config.center ", move position center");
                };
              };
              hypr = {
                class = mkOption {
                  type = types.nullOr types.str;
                  default = config.criteria.class or config.criteria.app_id or config.criteria.instance or null;
                };
                match_by = mkOption {
                  type = types.nullOr types.str;
                  default = if config.hypr.process_tracking then null else "class";
                };
                animation = mkOption {
                  type = types.enum [
                    ""
                    "fromTop"
                    "fromBottom"
                    "fromLeft"
                    "fromRight"
                  ];
                  default = "";
                };
                multi = mkOption {
                  type = types.bool;
                  default = true;
                };
                pinned = mkOption {
                  type = types.bool;
                  default = false;
                };
                excludes = mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                };
                restore_excluded = mkOption {
                  type = types.bool;
                  default = false;
                };
                unfocus = mkOption {
                  type = types.enum [
                    ""
                    "hide"
                  ];
                  default = "";
                };
                hysteresis = mkOption {
                  type = types.float;
                  default = 0.4;
                };
                lazy = mkOption {
                  type = types.bool;
                  default = !(config.hypr.process_tracking && config.autostart);
                };
                process_tracking = mkOption {
                  type = types.bool;
                  default = true;
                };
              };
              resize = mkOption {
                type = types.nullOr (
                  types.coercedTo types.int (e: [
                    e
                    e
                  ]) (types.listOf types.int)
                );
                default = null;
              };
              center = mkOption {
                type = types.bool;
                default = true;
              };
              startup = mkOption {
                type = types.nullOr types.str;
                default = null;
              };
              systemdCat = mkEnableOption "pipe output with systemd-cat";
              name = mkOption {
                type = types.str;
                default =
                  config.criteria.app_id or config.criteria.instance or config.criteria.class or config.startup
                    or "<unknown>";
              };
              automove = mkOption {
                type = types.bool;
                default = false;
              };
              autostart = mkEnableOption "starting this program at desktop start";
            };
          config = { };
        }
      )
    ];
  };
in
{
  options = {
    desktop.scratchpads = lib.mkOption {
      type = lib.types.attrsOf scratchpad;
      default = { };
    };
  };
  config = {
    desktop.keybinds = {
      "scratchpadToggleGeneric" = {
        modifiers = [ "MOD3" ];
        keysym = "Minus";
        description = "toggle generic scratchpad";
        hypr = {
          enable = true;
          dispatcher = lib.mkDefault "togglespecialworkspace";
          args = lib.mkDefault [ "scratchpad" ];
        };
      };
      "windowSendToScratchpadGeneric" = {
        modifiers = [
          "MOD3"
          "SHIFT"
        ];
        keysym = "Minus";
        description = "send active window to generic scratchpad";
        hypr = {
          enable = true;
          dispatcher = lib.mkDefault "movetoworkspacesilent";
          args = lib.mkDefault [ "special:scratchpad" ];
        };
      };
    }
    // (lib.mapAttrs' (
      name: pad:
      let
        isMod =
          key:
          let
            k = lib.toLower key;
          in
          k == "shift" || k == "ctrl" || k == "alt" || (lib.hasPrefix "mod" k);
        keys = lib.splitString "+" (lib.trim pad.kb);
      in
      {
        name = "scratchpadToggle_${pad.name}";
        value = {
          modifiers = (lib.optional pad.useMod "MOD3") ++ (map (lib.toUpper) (filter isMod keys));
          keysym = lib.findFirst (key: !(isMod key)) null keys;
          description = "toggle scratchpad: ${pad.name}";
          hypr = {
            enable = config.wayland.windowManager.hyprland.pyprland.enable;
            dispatcher = "execr";
            args = [ "pypr toggle ${pad.name}" ];
          };
        };
      }
    ) config.desktop.scratchpads);
  };
}
