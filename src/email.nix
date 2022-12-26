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
    signal.desktop.scratch.scratchpads = {
      "Shift+E" = {
        criteria = {
          app_id = "^thunderbird.*";
          title = "^(?!Write).*";
        };
        resize = 93;
        startup = "thunderbird";
        automove = true;
        autostart = true;
      };
    };
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
