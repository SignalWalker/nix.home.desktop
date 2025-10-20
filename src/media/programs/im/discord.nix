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
        pkgs.vesktop
        pkgs.dissent
      ];

      stylix.targets = {
        nixcord.enable = false;
        vencord.enable = false;
      };

      desktop.scratchpads = {
        "Shift+D" = {
          criteria = {
            class = "so.libdb.dissent";
          };
          name = "discord";
          resize = 93;
          startup = "dissent";
          systemdCat = true;
          autostart = true;
          automove = true;
        };
      };
    };
  meta = { };
}
