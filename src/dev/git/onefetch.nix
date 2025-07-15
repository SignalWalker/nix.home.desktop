{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  onefetch = config.programs.onefetch;
in {
  options = with lib; {
    programs.onefetch = {
      enable = mkEnableOption "onefetch";
      package = mkPackageOption pkgs "onefetch" {};
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf onefetch.enable {
    home.packages = [onefetch.package];
  };
  meta = {};
}
