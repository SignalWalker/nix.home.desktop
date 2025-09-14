{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  std = pkgs.lib;
  discord = config.programs.discord;
in
{
  options = with lib; {
  };
  disabledModules = [ ];
  imports = [ ];
  config = (
    # let
    #   pkg = discord.package.override {
    #     withOpenASAR = discord.openasar.enable;
    #     withVencord = discord.vencord.enable;
    #   };
    # in
    {
      # home.packages = [
      #   pkg
      # ];

      # programs.vesktop = {
      #   enable = true;
      # };

      # programs.nixcord = {
      #   enable = true;
      #   vesktop.enable = true;
      #   config = {
      #     useQuickCss = false;
      #     themeLinks = [
      #       "https://minidiscordthemes.github.io/Pesterchum/Pesterchum.theme.css"
      #     ];
      #   };
      #   dorion = {
      #     enable = true;
      #     autoClearCache = true;
      #     cacheCss = true;
      #     desktopNotifications = true;
      #     sysTray = true;
      #     useNativeTitlebar = true;
      #     extraSettings = {
      #
      #     };
      #   };
      # };

      home.packages = [
        pkgs.dorion
        pkgs.vesktop
      ];

      stylix.targets = {
        nixcord.enable = false;
        vencord.enable = false;
      };

      desktop.scratchpads = {
        "Shift+D" = {
          criteria = {
            app_id = "Dorion";
          };
          resize = 93;
          startup = "Dorion";
          systemdCat = true;
          automove = true;
        };
      };
    });
  meta = { };
}
