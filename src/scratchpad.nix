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
              criteria = mkOption {
                type = types.attrsOf types.str;
                readOnly = true;
                default = mapAttrs (key: val:
                  if val == false
                  then "false"
                  else toString val)
                config.criteria;
              };
              show = mkOption {
                type = types.str;
                readOnly = true;
                default = let
                  criteria = std.concatStringsSep " " (map (key: "${key}=\"${config.sway.criteria.${key}}\"") (attrNames config.sway.criteria));
                in
                  "[${criteria}] scratchpad show"
                  + (std.optionalString (config.resize != null) ", resize set ${config.resize}")
                  + (std.optionalString config.center ", move position center");
              };
            };
            hypr = {
              criteria = mkOption {
                type = types.attrsOf types.str;
                readOnly = true;
                default = mapAttrs (key: val:
                  if val == false
                  then "false"
                  else toString val)
                config.criteria;
              };
              show = mkOption {
                type = types.str;
                readOnly = true;
                default = "exec,echo buh";
              };
            };
            resize = mkOption {
              type = let
                dimsToStr = dims: "width ${toString (elemAt dims 0)} ppt height ${toString (elemAt dims 1)} ppt";
              in
                types.nullOr (types.coercedTo (types.either (types.listOf types.int) types.int)
                  (e:
                    dimsToStr (
                      if isInt e
                      then [e e]
                      else e
                    ))
                  types.str);
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
