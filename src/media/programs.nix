{
  pkgs,
  lib,
  ...
}:
{
  imports = lib.listFilePaths ./programs;
  config = {
    home.packages = [
      pkgs.qbittorrent
      pkgs.deluge
    ];
  };
}

