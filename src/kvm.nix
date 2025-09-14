{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
{
  imports = lib.listFilePaths ./kvm;
  config = {

    assertions = [
      {
        assertion =
          config.programs.lan-mouse.enable
          -> (config.wayland.windowManager.hyprland.enable && osConfig.programs.hyprland.withUWSM);
        message = "todo :: lan-mouse for non-hyprland cfg";
      }
    ];

    programs.lan-mouse = {
      enable = false;
      systemd = false;
    };

    systemd.user.services.lan-mouse = lib.mkIf config.programs.lan-mouse.enable {
      Install.WantedBy = [
        "wayland-session@Hyprland.target"
      ];
    };

    # services.input-leap = {
    #   client.enable = false;
    #   server.enable = false;
    # };
  };
}

