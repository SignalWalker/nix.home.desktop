{
  osConfig,
  pkgs,
  lib,
  ...
}:
{
  options = { };
  disabledModules = [ ];
  imports = [ ];
  config = lib.mkIf (osConfig.virtualisation.libvirtd.enable or false) {
    home.packages = [
      pkgs.virt-manager
    ];

    dconf.settings."org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
  meta = { };
}
