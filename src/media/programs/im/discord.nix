{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  discord = config.programs.discord;
in {
  options = with lib; {
    programs.discord = {
      enable = mkEnableOption "Discord";
      package = mkPackageOption pkgs "discord" {};
      vencord.enable = mkEnableOption "Vencord";
      openasar.enable = mkEnableOption "OpenASAR";
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf discord.enable {
    home.packages = [
      (discord.package.override {
        withOpenASAR = discord.openasar.enable;
        withVencord = discord.vencord.enable;
      })
    ];

    desktop.scratchpads = {
      "Shift+D" = {
        criteria = {
          app_id = "discord";
          # class = "discord";
        };
        resize = 93;
        startup = "${discord.package}/bin/discord";
        systemdCat = true;
        automove = true;
      };
    };
  };
  meta = {};
}
