{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  zelda = config.programs.harkinian;
in {
  options = with lib; {
    programs.harkinian = {
      enable = mkEnableOption "Ship of Harkinian";
      src = mkOption {
        type = types.path;
        default = config.signal.media.flakeInputs.harkinian;
      };
      package = mkOption {
        type = types.package;
        default = pkgs.llvmPackages_latest.mkDerivation {
          src = zelda.src;
          nativeBuildInputs = with pkgs; [ninja cmake python311 SDL2 libpng glew];
        };
      };
    };
  };
  disabledModules = [];
  imports = [];
  config =
    lib.mkIf zelda.enabled {
    };
  meta = {};
}
