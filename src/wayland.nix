{
  pkgs,
  lib,
  ...
}:
{
  options = {
  };
  imports = lib.listFilePaths ./wayland;
  config = {
    home.packages = [
      # meta
      pkgs.wev
      pkgs.wl-clipboard
      pkgs.xdg-utils
    ];
    xdg.configFile."electron-flags.conf".text = ''
      --enable-features=WaylandWindowDecorations
      --ozone-platform-hint=auto
    '';
  };
}

