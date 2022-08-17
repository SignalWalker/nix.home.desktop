{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.services.X11;
in {
  options.services.X11.rofi = with lib; {
    enable = (mkEnableOption "Rofi") // {default = true;};
  };
  imports = [];
  config = lib.mkIf (cfg.enable && cfg.rofi.enable) {
    programs.rofi = {
      enable = cfg.rofi.enable;
      configPath = "${config.xdg.configHome}/rofi/config.rasi";
      font = "${config.theme.font.mono.name} 10";
      terminal = "kitty";
      theme = "gruvbox-dark-hard";
      extraConfig = {
        sort = true;
        sorting-method = "fzf";
        modi = "drun,run";
      };
    };
  };
}
