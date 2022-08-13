{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.dev.lang.haskell;
in {
  options.dev.lang.haskell = with lib; {
    enable = mkEnableOption "Haskell language";
  };
  imports = [];
  config = lib.mkIf (config.dev.enable && cfg.enable) {
    home.packages = with pkgs; [
      # ghc
      # stack
      # cabal-install
      haskell-language-server
      ormolu
    ];
    home.sessionPath = [ "${config.home.homeDirectory}/.cabal/bin" ];
  };
}
