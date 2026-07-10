{
  pkgs,
  ...
}:
{
  config = {

    desktop.scratchpads = {
      "Shift+M" = {
        criteria = {
          app_id = "org.gnome.Fractal";
        };
        resize = 93;
        startup = "fractal";
        systemdCat = true;
        autostart = false;
        automove = true;
      };
    };
  };
  meta = { };
}
