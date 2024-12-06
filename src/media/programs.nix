{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  imports = lib.signal.fs.path.listFilePaths ./programs;
  config = {
    home.packages = with pkgs; [
      qbittorrent
      deluge
    ];
  };
}
