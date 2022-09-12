inputs @ {
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.x11;
in {
  options.signal.desktop.x11 = with inputs.lib; {
    enable = mkEnableOption "X11-specific configuration.";
  };
  imports = lib.signal.fs.path.listFilePaths ./x11;
  config = lib.mkIf cfg.enable {
    programs.feh = {
      enable = cfg.enable;
    };

    home.pointerCursor.x11 = {
      enable = cfg.enable;
      defaultCursor = "left_ptr";
    };
  };
}
