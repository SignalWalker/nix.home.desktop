{
  ...
}:
{
  config = {
    services.gammastep = {
      enable = false; # can't find geoclue for some reason
      provider = "geoclue2";
      tray = true;
      settings = {
        general = {
          "adjustment-method" = "wayland";
        };
        wayland = {

        };
      };
    };
  };
}
