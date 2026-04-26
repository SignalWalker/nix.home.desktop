{
  config,
  lib,
  ...
}:
{
  config =
    let
      rescrobbledCfg = "rescrobbledCfg";
    in
    {
      # age.secrets.${rescrobbledCfg} = {
      #   file = ./secrets/rescrobbledCfg.age;
      # };
      # services.rescrobbled = {
      #   enable = false;
      # };
      # systemd.user.services.rescrobbled.Unit = {
      #   Wants = [
      #     "agenix.service"
      #   ];
      #   After = [
      #     "agenix.service"
      #   ];
      # };
      # home.activation.rescrobbledCfg = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      #   run mkdir $VERBOSE_ARG -p "${config.xdg.configHome}/rescrobbled"
      #   run ln $VERBOSE_ARG -sfT "''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/agenix/${rescrobbledCfg}" "${config.xdg.configHome}/rescrobbled/config.toml"
      # '';
    };
}
