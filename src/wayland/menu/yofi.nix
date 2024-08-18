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
  theme = config.desktop.theme;
  font = theme.font;
in {
  options = with lib; {
    desktop.launcher.yofi = {
      enable = mkEnableOption "yofi launcher config";
    };
    programs.yofi = {
      enable = mkEnableOption "yofi";
      package = mkPackageOption pkgs "yofi" {};
      settings = mkOption {
        type = toml.type;
        default = {};
      };
      ignore = mkOption {
        type = types.listOf types.str;
        default = [];
      };
      settingsFile = mkOption {
        type = types.path;
        readOnly = true;
        default = toml.generate "yofi.config" yofi.settings;
      };
      ignoreFile = mkOption {
        type = types.path;
        readOnly = true;
        default = pkgs.writeText "yofi-ignore-list" (std.concatStringsSep "\n" yofi.ignore);
      };
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkMerge [
    (lib.mkIf launcher.yofi.enable {
      programs.yofi = {
        enable = true;
        settings = let
          font = head theme.font.sans;
        in {
          term = "${config.desktop.terminal.command}";

          font = font.name;
          font_size = font.selectSize 16;

          icon = {
            theme = config.gtk.iconTheme.name;
          };

          input_text = {
            corner_radius = "0";
          };

          list_items = {
            hide_actions = true;
          };
        };
      };
      desktop.launcher = {
        run = "${yofi.package}/bin/yofi binapps";
        drun = "${yofi.package}/bin/yofi apps";
      };
    })
    (lib.mkIf yofi.enable {
      home.packages = [yofi.package];
      xdg.configFile."yofi/yofi.config" = {
        source = yofi.settingsFile;
      };
      xdg.configFile."yofi/blacklist" = lib.mkIf (yofi.ignore != []) {
        source = yofi.ignoreFile;
      };
    })
  ];
  meta = {};
}
