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
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = lib.mkMerge [
    (lib.mkIf osConfig.networking.networkmanager.enable {
      services.network-manager-applet.enable = true;
    })
    # (lib.mkIf osConfig.networking.wireless.iwd.enable {
    #   home.packages = [pkgs.iwgtk];
    # })
  ];
  meta = {};
}
