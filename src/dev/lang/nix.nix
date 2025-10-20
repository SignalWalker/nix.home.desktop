{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
  };
  imports = lib.listFilePaths ./nix;
  config = {
    home.packages = [
      pkgs.agenix
      pkgs.snowfallorg.thaw
      pkgs.deploy-rs
    ];
    programs.jq.enable = lib.mkDefault true;
  };
}

