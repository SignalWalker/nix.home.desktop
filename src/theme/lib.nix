{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  tcfg = config.desktop.theme;
  tlib = tcfg.font.types;
  submodule = module: lib.types.submoduleWith {modules = [module];};
in {
  options = with lib; {
    desktop.theme.font.types = let
      fontFamilyModule = {
        config,
        lib,
        name,
        ...
      }: {
        options = with lib; {
          package = mkOption {
            type = types.package;
          };
          name = mkOption {
            type = types.str;
            default = name;
          };
          formats = mkOption {
            type = types.listOf types.str;
            default = [];
          };
          pixelsizes = mkOption {
            type = types.nullOr (types.listOf types.int);
            default = null;
          };
          styles = mkOption {
            type = types.listOf types.str;
            default = [];
          };
          slants = mkOption {
            type = types.listOf types.int;
            default = [];
          };
          weights = mkOption {
            type = types.listOf types.int;
            default = [];
          };
          # functions
          selectSize = mkOption {
            type = types.functionTo types.int;
            default = ideal: let
              abs = val:
                if val < 0
                then val * -1
                else val;
            in
              if config.pixelsizes != null
              then
                (foldl' (res: val:
                  if res == [] || ((abs (ideal - val)) < (abs (ideal - res)))
                  then val
                  else res) []
                config.pixelsizes)
              else ideal;
          };
        };
      };
    in
      mkOption {
        type = types.attrsOf types.optionType;
        readOnly = true;
        default = {
          fontFamily = types.submoduleWith {modules = [fontFamilyModule];};
          font = types.submoduleWith {
            modules = [
              ({
                config,
                lib,
                ...
              }: {
                options = with lib; {
                  package = mkOption {
                    type = types.nullOr types.package;
                    default = null;
                  };
                  families = mkOption {
                    description = "Set of font families.";
                    type =
                      types.lazyAttrsOf #tlib.fontFamily;
                      
                      (types.submoduleWith {
                        modules = [fontFamilyModule ({...}: {config.package = lib.mkDefault config.package;})];
                      });
                  };
                };
                config = {
                  families.default = lib.mkDefault config.families.${head (filter (key: key != "default" && ((substring 0 1 key) != "_")) (attrNames config.families))};
                };
              })
            ];
          };
        };
      };
  };
  imports = [];
  config = {};
}