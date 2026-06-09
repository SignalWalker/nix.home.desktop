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
          modifiers = [ "MOD3" ];
          keysym = "B";
          description = "toggle shell dashboard";
        };
        sessionMenuToggle = {
          modifiers = [ "MOD3" ];
          keysym = "S";
          description = "toggle session menu";
        };
        controlCenterToggle = {
          modifiers = [
            "MOD3"
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
