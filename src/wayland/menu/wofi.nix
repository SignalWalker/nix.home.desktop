{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.programs.wofi;
in {
  options.programs.wofi = with lib; {
    enable = mkEnableOption "wofi menu";
    package = mkOption {
      type = types.package;
      default = pkgs.wofi;
    };
    settings = mkOption {
      type = types.attrsOf types.anything;
      default = {};
    };
    style = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
    xdg.configFile = lib.mkMerge [
      {
        "wofi/config".text =
          foldl'
          (
            acc: key: let
              val = cfg.settings.${key};
              sep =
                if acc == ""
                then ""
                else "\n";
              valStr =
                if isBool val
                then
                  (
                    if val
                    then "true"
                    else "false"
                  )
                else (toString val);
            in
              acc + "${sep}${key}=${valStr}"
          ) ""
          (attrNames cfg.settings);
      }
      (lib.mkIf (cfg.style != null) {
        "wofi/style.css".text = cfg.style;
      })
    ];
  };
  meta = {};
}
