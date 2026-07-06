{
  osConfig,
  lib,
  ...
}:
{
  config = lib.mkMerge [
    (lib.mkIf osConfig.networking.networkmanager.enable {
      services.network-manager-applet.enable = false;
    })
    # (lib.mkIf osConfig.networking.wireless.iwd.enable {
    #   home.packages = [pkgs.iwgtk];
    # })
    {
      desktop.keybinds = {
        networkMenuToggle = {
          modifiers = [ "MOD3" ];
          keysym = "E";
          description = "toggle network settings menu";
        };
      };
    }
  ];
  meta = { };
}
