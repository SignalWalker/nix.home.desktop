{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.dev.lang.js;
in {
  options.signal.dev.lang.js = with lib; {
    enable = (mkEnableOption "JavaScript language") // { default = true; };
  };
  imports = [];
  config = lib.mkIf (cfg.enable) {
    programs.jq.enable = true;
    systemd.user.sessionVariables.npm_config_prefix = "${config.home.homeDirectory}/.local/npm";
    home.sessionPath = [ "${config.systemd.user.sessionVariables.npm_config_prefix}/bin" ];
  };
}
