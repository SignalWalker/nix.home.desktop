{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.media.im.matrix;
in {
  options.signal.media.im.matrix = with lib; {
    enable = (mkEnableOption "Matrix") // {default = true;};
    package = mkOption {
      type = types.package;
      default = pkgs.element-desktop;
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      cfg.package
    ];

    signal.desktop.scratch.scratchpads = {
      "Shift+M" = {
        criteria = {
          app_id = "Element";
        };
        resize = 93;
        startup = "element-desktop";
        systemdCat = true;
        autostart = true;
        automove = true;
      };
    };
  };
  meta = {};
}
