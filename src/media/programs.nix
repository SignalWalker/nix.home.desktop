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
  imports = lib.listFilePaths ./programs;
  config = {
    home.packages = with pkgs; [
      qbittorrent
      deluge
    ];
  };
}