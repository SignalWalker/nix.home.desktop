{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  rofi = config.desktop.launcher.rofi;
in {
  options = with lib; {
    desktop.launcher.rofi = {
      enable = mkEnableOption "X11/Wayland rofi config";
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf rofi.enable {
    desktop.launcher = let
      rofiBin = "${config.programs.rofi.package}/bin/rofi";
    in {
      drun = "${rofiBin}";
      run = "${rofiBin}";
    };
    programs.rofi = let
      fontSize = 13;
      font = head (config.desktop.theme.font.bmpsAt fontSize);
    in {
      enable = rofi.enable;
      configPath = "${config.xdg.configHome}/rofi/config.rasi";
      font = "${font.name} ${toString fontSize}";
      terminal = config.desktop.terminal.command;
      theme = "gruvbox-dark-hard";
      extraConfig = {
        sort = true;
        sorting-method = "fzf";
      };
    };
  };
  meta = {};
}
