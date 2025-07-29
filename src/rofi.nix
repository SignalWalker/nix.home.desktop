{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  std = pkgs.lib;
  rofi = config.desktop.launcher.rofi;
in
{
  options = with lib; {
    desktop.launcher.rofi = {
      enable = mkEnableOption "X11/Wayland rofi config";
    };
  };
  disabledModules = [ ];
  imports = [ ];
  config = lib.mkIf rofi.enable {
    desktop.launcher =
      let
        rofiBin = "${config.programs.rofi.package}/bin/rofi";
      in
      {
        drun = "${rofiBin}";
        run = "${rofiBin}";
      };
    programs.rofi =
      let
      in
      {
        enable = rofi.enable;
        configPath = "${config.xdg.configHome}/rofi/config.rasi";
        terminal = config.desktop.terminal.command;
        extraConfig = {
          sort = true;
          sorting-method = "fzf";
        };
      };
  };
  meta = { };
}
