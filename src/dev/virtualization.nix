{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
let
  virt = config.signal.dev.virtualization;
in
{
  options = {
    signal.dev.virtualization = {
      enable = (lib.mkEnableOption "virtualization") // {
        default = osConfig.virtualisation.libvirtd.enable;
      };
    };
  };
  disabledModules = [ ];
  imports = [ ];
  config = lib.mkIf virt.enable {
    # from https://nixos.wiki/wiki/Libvirt
    xdg.configFile."libvirt/qemu.conf".text = ''
      nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]
    '';
    home.packages = [ pkgs.virt-manager ];
  };
  meta = { };
}
