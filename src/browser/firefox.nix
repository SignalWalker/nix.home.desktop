{
  pkgs,
  ...
}:
{
  config =
    let
      firefoxCmd = "firefox";
    in
    {
      desktop.scratchpads = {
        "Shift+F" = {
          criteria = {
            app_id = "^firefox*";
          };
          hypr = {
            class = firefoxCmd;
          };
          resize = 93;
          startup = firefoxCmd;
          name = "firefox";
          systemdCat = true;
        };
      };
      systemd.user.sessionVariables = {
        BROWSER = firefoxCmd;
        MOZ_DBUS_REMOTE = 1;
      };
      programs.firefox = {
        enable = true;
        package = pkgs.firefox-bin;
        profiles = {
          main = {
            id = 0;
            name = "main";
            isDefault = true;
          };
        };
      };
      stylix.targets.firefox.profileNames = [ "main" ];
    };
  meta = { };
}
