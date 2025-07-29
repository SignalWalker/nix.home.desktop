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

      programs.vesktop = {
        enable = true;
      };

      desktop.scratchpads = {
        "Shift+D" = {
          criteria = {
            app_id = "vesktop";
            class = "vesktop";
          };
          hypr = {
            process_tracking = false;
          };
          resize = 93;
          startup = "vesktop";
          systemdCat = true;
          automove = true;
        };
      };
    });
  meta = { };
}
