{
  config,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  fnott = config.services.fnott;
in
{
  options = with lib; { };
  disabledModules = [ ];
  imports = [ ];
  config = lib.mkIf fnott.enable {
    desktop.notifications = {
      commands =
        let
          ctl = "${fnott.package}/bin/fnottctl";
        in
        {
          # restore = "${ctl} ";
          dismiss = "${ctl} dismiss";
          context = "${ctl} actions";
        };
    };
  };
  meta = { };
}
