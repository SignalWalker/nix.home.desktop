{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  yofi = config.programs.yofi;
  toml = pkgs.formats.toml {};
in {
  options = with lib; {
    programs.yofi = {
      enable = mkEnableOption "yofi";
      package = mkPackageOption pkgs "yofi" {};
      settings = mkOption {
        type = toml.type;
        default = {};
      };
      settingsFile = mkOption {
        type = types.path;
        readOnly = true;
        default = toml.generate "yofi.config" yofi.settings;
      };
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf yofi.enable {
    home.packages = [yofi.package];
    xdg.configFile."yofi/yofi.config" = {
      source = yofi.settingsFile;
    };
  };
  meta = {};
}
