{
  lib,
  ...
}:
{
  options = {
  };
  imports = [
    ./shell/noctalia.nix
  ];
  config = lib.mkMerge [
    {
      programs.noctalia = {
        enable = true;
        # config in ./shell/noctalia.nix
      };

      # generic keybinds
      desktop.keybinds = {
        dashboardToggle = {
          modifiers = [ "SUPER" ];
          keysym = "M";
          description = "toggle shell dashboard";
        };
        sessionMenuToggle = {
          modifiers = [ "SUPER" ];
          keysym = "S";
          description = "toggle session menu";
        };
        controlCenterToggle = {
          modifiers = [
            "SUPER"
            "CTRL"
          ];
          keysym = "S";
          description = "toggle control center";
        };
      };
    }
  ];
  meta = { };
}
