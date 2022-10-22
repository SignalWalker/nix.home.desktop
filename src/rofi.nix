{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.shared.rofi;
in {
  options.signal.desktop.shared.rofi = with lib; {
    enable = mkEnableOption "X11/Wayland rofi config";
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf cfg.enable {
    programs.rofi = let
      fontSize = 13;
      font = head (config.lib.signal.desktop.theme.bmpsAt fontSize);
    in {
      enable = cfg.enable;
      configPath = "${config.xdg.configHome}/rofi/config.rasi";
      font = "${font.family} ${toString fontSize}";
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
