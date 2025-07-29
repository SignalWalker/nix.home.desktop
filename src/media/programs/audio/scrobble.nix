{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  std = pkgs.lib;
in
{
  options = with lib; { };
  disabledModules = [ ];
  imports = [ ];
  config = {
    age.secrets."rescrobbledCfg" = {
      file = ./secrets/rescrobbledCfg.age;
    };
    services.rescrobbled = {
      enable = true;
    };
    systemd.user.services.rescrobbled.Unit = {
      Wants = [
        "agenix.service"
      ];
      After = [
        "agenix.service"
      ];
    };
    home.activation.rescrobbledCfg = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir $VERBOSE_ARG -p "${config.xdg.configHome}/rescrobbled"
      run ln $VERBOSE_ARG -sfT "${
        config.age.secrets."rescrobbledCfg".path
      }" "${config.xdg.configHome}/rescrobbled/config.toml"
    '';
  };
  meta = { };
}
