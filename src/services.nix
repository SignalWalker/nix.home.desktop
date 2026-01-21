{
  ...
}:
{
  # imports = lib.listFilePaths ./services;
  config = {
    # services.watch-battery.enable = true;
    # services.blueman-applet.enable = true;
    services.systembus-notify = {
      enable = true;
    };
    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "auto";
    };
  };
}
