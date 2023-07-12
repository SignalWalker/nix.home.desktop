{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = lib.mkMerge [
    {
      signal.desktop.scratch.scratchpads = {
        "Shift+V" = {
          criteria = {app_id = "pavucontrol";};
          resize = 50;
          startup = "pavucontrol";
          autostart = true;
          automove = true;
        };
      };
      services.playerctld = {
        enable = true;
      };
    }
    (lib.mkIf config.system.isNixOS {
      home.packages = with pkgs; [
        pavucontrol
      ];
    })
  ];
  meta = {};
}
