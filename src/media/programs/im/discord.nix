{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.media.im.discord;
in {
  options.signal.media.im.discord = with lib; {
    enable = (mkEnableOption "Discord") // {default = true;};
    package = mkOption {
      type = types.package;
      default = pkgs.discord;
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      cfg.package
    ];

    signal.desktop.wayland.compositor.scratchpads = [
      {
        kb = "Shift+D";
        criteria = {class = "discord";};
        resize = 93;
        startup = "discord";
      }
    ];
  };
  meta = {};
}
