{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.dev.lang.js;
in {
  options.dev.lang.js = with lib; {
    enable = mkEnableOption "JavaScript language";
  };
  imports = [];
  config = lib.mkIf (config.dev.enable && cfg.enable) {
    programs.jq.enable = true;
    systemd.user.sessionVariables.npm_config_prefix = "${config.home.homeDirectory}/.local/npm";
    home.sessionPath = [ "${config.systemd.user.sessionVariables.npm_config_prefix}/bin" ];
  };
}
