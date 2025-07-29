{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  std = pkgs.lib;
in
{
  options.signal.desktop.browser.firefox = with lib; { };
  disabledModules = [ ];
  imports = [ ];
  config =
    let
      firefoxCmd = "firefox-beta";
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
      desktop.windows = [
        {
          criteria = {
            app_id = "^firefox*";
            title = "Extension: .*";
          };
          floating = true;
        }
      ];
      systemd.user.sessionVariables = {
        BROWSER = firefoxCmd;
        MOZ_DBUS_REMOTE = 1;
      };
      programs.firefox = {
        enable = true;
        package = pkgs.firefox-beta;
        # package = pkgs.latest.firefox-nightly-bin;
        # package = pkgs.firefox-beta-bin;
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
