{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.x11;
  mcfg = config.signal.desktop.x11.menu;
in {
  options.signal.desktop.x11.menu = with lib; {
    enable = (mkEnableOption "system menu") // {default = true;};
  };
  imports = [];
  config = lib.mkIf (cfg.enable && mcfg.enable) {
    programs.rofi = let
      fontSize = 13;
      font = head (config.lib.signal.desktop.theme.bmpsAt fontSize);
    in {
      enable = mcfg.enable;
      configPath = "${config.xdg.configHome}/rofi/config.rasi";
      font = "${font.family} ${toString fontSize}";
      terminal = config.signal.desktop.terminal.command;
      theme = "gruvbox-dark-hard";
      extraConfig = {
        sort = true;
        sorting-method = "fzf";
        modi = "drun,run";
      };
    };
  };
}
