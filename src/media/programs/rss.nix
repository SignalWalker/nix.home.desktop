{
  pkgs,
  ...
}:
{
  config = {
    home.packages = [ pkgs.rssguard ];
    desktop.scratchpads = {
      "Shift+R" = {
        criteria = {
          app_id = "io.github.martinrotter.rssguard";
          # title = "^(\\[[0-9]*\\] )?RSS Guard [0-9]\\.[0-9]\\.[0-9]";
        };
        hypr = {
        };
        name = "rssguard";
        resize = 93;
        startup = "rssguard";
        systemdCat = true;
        automove = true;
        autostart = false;
      };
    };
  };
  meta = { };
}
