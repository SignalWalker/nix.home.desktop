{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  imports = lib.signal.fs.path.listFilePaths ./kvm;
  config = {
    home.packages = with pkgs; [
      lan-mouse
    ];
    services.input-leap = {
      client.enable = false;
      server.enable = false;
    };
  };
}
