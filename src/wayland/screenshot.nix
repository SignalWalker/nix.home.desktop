{
  pkgs,
  lib,
  ...
}:
{
  config = {
    home.packages = [
      pkgs.grim
      pkgs.slurp
      pkgs.sway-contrib.grimshot
      pkgs.libnotify
    ];
    desktop.keybinds =
      let
        script = ./scripts/screenshot;
      in
      {
        screenshotActive = {
          modifiers = [ ];
          keysym = "Print";
          description = "screenshot active window";
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "${script} active" ];
          };
        };
        screenshotArea = {
          modifiers = [ "CTRL" ];
          keysym = "Print";
          description = "screenshot selected region";
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "${script} area" ];
          };
        };
        screenshotOutput = {
          modifiers = [ "Super" ];
          keysym = "Print";
          description = "screenshot active output";
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "${script} output" ];
          };
        };
        screenshotAll = {
          modifiers = [
            "Super"
            "ALT"
          ];
          keysym = "Print";
          description = "screenshot all outputs";
          hypr = {
            enable = true;
            dispatcher = lib.mkDefault "exec_raw";
            args = lib.mkDefault [ "${script} screen" ];
          };
        };
      };
  };
  meta = { };
}
