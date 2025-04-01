{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  scratchpad = with lib;
    types.submoduleWith {
      modules = [
        ({
          config,
          lib,
          pkgs,
          name,
          ...
        }: {
          options = with lib; {
            kb = mkOption {
              type = types.str;
              default = name;
            };
            useMod = (mkEnableOption "modifier key in keybind") // {default = true;};
            criteria = mkOption {
              type = types.attrsOf (types.oneOf [types.bool types.int types.str]);
              default = {};
            };
            criteriaStr = mkOption {
              type = types.attrsOf types.str;
              readOnly = true;
              default = mapAttrs (key: val:
                if val == false
                then "false"
                else toString val)
              config.criteria;
            };
            exec = mkOption {
              type = types.nullOr types.str;
              readOnly = true;
              default =
                if config.startup == null
                then null
                else if config.systemdCat
                then "systemd-cat --identifier=${config.name} ${config.startup}"
                else config.startup;
            };
            sway = {
              resize = mkOption {
                type = types.nullOr types.str;
                readOnly = true;
                default = let
                  dimsToStr = dims: "width ${toString (elemAt dims 0)} ppt height ${toString (elemAt dims 1)} ppt";
                in (
                  if config.resize == null
                  then null
                  else (dimsToStr config.resize)
                );
              };
              show = mkOption {
                type = types.str;
                readOnly = true;
                default = let
                  criteria = std.concatStringsSep " " (map (key: "${key}=\"${config.criteriaStr.${key}}\"") (attrNames config.criteriaStr));
                in
                  "[${criteria}] scratchpad show"
                  + (std.optionalString (config.sway.resize != null) ", resize set ${config.sway.resize}")
                  + (std.optionalString config.center ", move position center");
              };
            };
            hypr = {
              class = mkOption {
                type = types.nullOr types.str;
                default = config.criteria.class or config.criteria.app_id or config.criteria.instance or null;
              };
              match_by = mkOption {
                type = types.nullOr types.str;
                default =
                  if config.hypr.process_tracking
                  then null
                  else "class";
              };
              animation = mkOption {
                type = types.enum ["" "fromTop" "fromBottom" "fromLeft" "fromRight"];
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
                default = [];
              };
              restore_excluded = mkOption {
                type = types.bool;
                default = false;
              };
              unfocus = mkOption {
                type = types.enum ["" "hide"];
                default = "";
              };
              hysteresis = mkOption {
                type = types.float;
                default = 0.4;
              };
              lazy = mkOption {
                type = types.bool;
                default = !config.autostart;
              };
              process_tracking = mkOption {
                type = types.bool;
                default = true;
              };
            };
            resize = mkOption {
              type = types.nullOr (types.coercedTo types.int
                (e: [e e])
                (types.listOf types.int));
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
              default = config.criteria.app_id or config.criteria.instance or config.criteria.class or config.startup or "<unknown>";
            };
            automove = mkOption {
              type = types.bool;
              default = false;
            };
            autostart = mkEnableOption "starting this program at desktop start";
          };
          config = {};
        })
      ];
    };
in {
  options = with lib; {
    desktop.scratchpads = mkOption {
      type = types.attrsOf scratchpad;
      default = {};
    };
  };
  disabledModules = [];
  imports = [];
  config = {};
  meta = {};
}
