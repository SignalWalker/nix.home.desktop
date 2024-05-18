{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  launcher = config.desktop.launcher;
  yofi = config.programs.yofi;
  toml = pkgs.formats.toml {};
in {
  options = with lib; {
    desktop.launcher.yofi = {
      enable = mkEnableOption "yofi launcher config";
    };
    programs.yofi = {
      enable = mkEnableOption "yofi";
      package = mkOption {
        type = types.package;
      };
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
  config = lib.mkMerge [
    (lib.mkIf launcher.yofi.enable {
      programs.yofi = {
        enable = true;
      };
      desktop.launcher = {
        run = "${yofi.package}/bin/yofi";
        drun = "${yofi.package}/bin/yofi";
      };
    })
    (lib.mkIf yofi.enable {
      home.packages = [yofi.package];
      xdg.configFile."yofi/yofi.config" = {
        source = yofi.settingsFile;
      };
    })
  ];
  meta = {};
}
