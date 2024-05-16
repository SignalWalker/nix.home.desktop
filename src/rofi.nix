{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  rofi = config.signal.desktop.shared.rofi;
in {
  options.signal.desktop.shared.rofi = with lib; {
    enable = (mkEnableOption "X11/Wayland rofi config") // {default = true;};
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf rofi.enable {
    signal.desktop.wayland.menu = let
      rofiBin = "${config.programs.rofi.package}/bin/rofi";
    in {
      drun = "${rofiBin}";
      run = "${rofiBin}";
    };
    programs.rofi = let
      fontSize = 13;
      font = head (config.signal.desktop.theme.font.bmpsAt fontSize);
    in {
      enable = rofi.enable;
      configPath = "${config.xdg.configHome}/rofi/config.rasi";
      font = "${font.name} ${toString fontSize}";
      terminal = config.signal.desktop.terminal.command;
      theme = "gruvbox-dark-hard";
      extraConfig = {
        sort = true;
        sorting-method = "fzf";
      };
    };
  };
  meta = {};
}
