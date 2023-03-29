{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = {
    systemd.user.sessionVariables = {
      IPFS_PATH = "${config.xdg.dataHome}/ipfs";
    };
  };
  meta = {};
}
