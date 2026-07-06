{
  config,
  pkgs,
  lib,
  ...
}:
let
  mux = config.services.lspmux;
in
{
  options =
    let
      inherit (lib) types mkOption mkEnableOption;
      toml = pkgs.formats.toml { };
    in
    {
      services.lspmux = {
        enable = mkEnableOption "lspmux";
        settings = mkOption {
          type = toml.type;
          default = { };
        };
        settingsFile = mkOption {
          type = types.path;
          readOnly = true;
          default = toml.generate "lspmux.config.toml" mux.settings;
        };
      };
    };
  config = lib.mkIf mux.enable {
    xdg.configFile."lspmux/config.toml".source = mux.settingsFile;
  };
}
