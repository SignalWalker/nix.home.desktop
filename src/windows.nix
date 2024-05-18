{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;

  window = lib.types.submoduleWith {
    modules = [
      ({
        config,
        lib,
        pkgs,
        ...
      }: {
        options = with lib; {
          criteria = mkOption {
            type = types.attrsOf (types.oneOf [types.int types.bool types.str]);
          };
          floating = mkEnableOption "open window as floating when applicable";
        };
      })
    ];
  };
in {
  options = with lib; {
    desktop.windows = mkOption {
      type = types.listOf window;
      default = [];
    };
  };
  disabledModules = [];
  imports = [];
  config = {};
  meta = {};
}
