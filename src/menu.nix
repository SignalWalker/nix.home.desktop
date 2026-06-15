{
  lib,
  ...
}:
{
  # options = with lib; {
  #   desktop.launcher = {
  #     enable = (mkEnableOption "desktop launcher") // {
  #       default = true;
  #     };
  #     run = mkOption {
  #       type = types.str;
  #     };
  #     drun = mkOption {
  #       type = types.str;
  #       default = launcher.run;
  #     };
  #   };
  # };
  config = {
    programs.elephant = {
      # enable = true; # NOTE :: enabled by walker
    };
    programs.walker = {
      enable = true;
      runAsService = true;
      config = {
        providers = {
          default = [ "desktopapplications" ];
        };
      };
    };
    desktop.keybinds = {
      launcherRun = {
        modifiers = [ "MOD3" ];
        keysym = "D";
        description = "open application launcher";
        hypr = {
          enable = true;
          dispatcher = lib.mkDefault "exec_raw";
          args = lib.mkDefault [ "walker" ];
        };
      };
      launcherRunAlt = {
        modifiers = [
          "MOD3"
          "ALT"
        ];
        keysym = "D";
        description = "open application launcher (alt)";
        hypr = {
          enable = true;
          dispatcher = lib.mkDefault "exec_raw";
          args = lib.mkDefault [ "walker" ];
        };
      };
    };
  };
  meta = { };
}