inputs @ {
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options.services.X11 = with inputs.lib; {
    enable = mkEnableOption "X11-specific configuration.";
  };
  imports = [
    ./src/autorandr.nix
    ./src/dunst.nix
    ./src/picom.nix
    ./src/polybar.nix
    ./src/rofi.nix
    ./src/socket.nix
    ./src/wired.nix
    ./src/xresources.nix
    ./src/xsession.nix
  ];
  config = let
    cfg = config.services.X11;
  in
    lib.mkIf cfg.enable {
      programs.feh = {
        enable = true;
      };

      home.pointerCursor.x11 = {
        enable = true;
        defaultCursor = "left_ptr";
      };
    };
}
