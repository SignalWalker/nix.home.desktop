{
  pkgs,
  ...
}:
{
  options.signal.desktop.email = { };
  disabledModules = [ ];
  imports = [ ];
  config = {
    desktop.scratchpads = {
      "Shift+E" = {
        criteria = {
          app_id = "^thunderbird.*";
          title = "^.* - Mozilla Thunderbird";
        };
        resize = 93;
        name = "thunderbird";
        startup = "thunderbird";
        systemdCat = true;
        automove = true;
        autostart = true;
      };
    };
    signal.email.thunderbird.enable = false;
    # programs.thunderbird = {
    #   enable = true;
    #   package = pkgs.thunderbird;
    # };
    home.packages = [
      pkgs.thunderbird
    ];
  };
  meta = { };
}
