{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  ql = config.programs.quodlibet;
in {
  options = with lib; {
    programs.quodlibet = {
      enable = mkEnableOption "quod libet";
      package = mkOption {
        type = types.package;
        default = pkgs.quodlibet-full.override {
          python3 = pkgs.python311; # workaround for https://github.com/NixOS/nixpkgs/issues/325537
        };
      };
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf ql.enable {
    home.packages = [ql.package];
  };
  meta = {};
}
