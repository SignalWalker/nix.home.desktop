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
  config = {
    home.packages = [pkgs.bottles];
    desktop.windows = [
      {
        criteria = {
          app_id = "com.usebottles.bottles";
          title = "Select Bottle";
        };
        floating = true;
      }
    ];
    xdg.binFile."wine-bottles" = {
      executable = true;
      text = ''
        #! ${pkgs.zsh}/bin/zsh
        bottles-cli run -b Standard -e "$@"
      '';
    };
  };
  meta = {};
}
