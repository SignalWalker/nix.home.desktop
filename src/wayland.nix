{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {
  };
  imports = lib.listFilePaths ./wayland;
  config = {
    home.packages = with pkgs; [
      # meta
      wev
      wl-clipboard
      xdg-utils
    ];
    xdg.configFile."electron-flags.conf".text = ''
      --enable-features=WaylandWindowDecorations
      --ozone-platform-hint=auto
    '';
  };
}