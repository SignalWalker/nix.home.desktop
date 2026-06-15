{
  pkgs,
  ...
}:
{
  config =
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
        # pkgs.dorion
        # pkgs.vesktop
        # pkgs.dissent # weird build issue 2025-11-19
      ];

      stylix.targets = {
        nixcord.enable = false;
        vencord.enable = false;
      };

      # NOTE :: this only works if you disable the splash screen in vesktop settings
      desktop.scratchpads = {
        "Shift+D" = {
          criteria = {
            app_id = "vesktop";
          };
          name = "discord";
          resize = 93;
          startup = "vesktop";
          autostart = false;
          automove = true;
        };
      };
    };
  meta = { };
}
