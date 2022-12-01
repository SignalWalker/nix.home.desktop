{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  accounts = config.accounts.email.accounts;
in {
  options.signal.desktop.email = with lib; {};
  disabledModules = [];
  imports = [];
  config = {
    signal.desktop.wayland.compositor.scratchpads = [
      {
        kb = "Shift+E";
        criteria = {app_id = "^thunderbird*";};
        resize = 93;
        startup = "thunderbird";
      }
    ];
    signal.email.thunderbird.enable = false;
    programs.thunderbird = {
      enable = true;
      package = pkgs.thunderbird;
      settings = {};
      profiles.main = {
        isDefault = true;
        settings = {};
      };
    };
  };
  meta = {};
}
