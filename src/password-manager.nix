{
  pkgs,
  ...
}:
{
  config = {
    home.packages = [
      pkgs.bitwarden-desktop
    ];

    desktop.scratchpads = {
      # "Shift+A" = {
      #   criteria = {class = "Authy Desktop";};
      #   startup = "authy";
      #   autostart = false;
      #   automove = false;
      # };
      "Shift+P" = {
        criteria = {
          app_id = "Bitwarden";
        };
        resize = 75;
        startup = "bitwarden";
        systemdCat = true;
        autostart = false;
        automove = true;
      };
    };
  };
}
