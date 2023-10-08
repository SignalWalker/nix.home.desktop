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
  config = lib.mkIf (osConfig.virtualisation.libvirtd.enable or false) {
    home.packages = with pkgs; [
      virt-manager
    ];

    dconf.settings."org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
  meta = {};
}
