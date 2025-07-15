{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  virt = config.signal.dev.virtualization;
in {
  options = with lib; {
    signal.dev.virtualization = {
      enable = (mkEnableOption "virtualization") // {default = osConfig.virtualisation.libvirtd.enable;};
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf virt.enable {
    # from https://nixos.wiki/wiki/Libvirt
    xdg.configFile."libvirt/qemu.conf".text = ''
      nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]
    '';
    home.packages = [pkgs.virt-manager];
  };
  meta = {};
}
