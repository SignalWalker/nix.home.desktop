{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  std = pkgs.lib;
  accounts = config.accounts.email.accounts;
in
{
  options.signal.desktop.email = with lib; { };
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
    home.packages = with pkgs; [
      thunderbird
    ];
  };
  meta = { };
}
