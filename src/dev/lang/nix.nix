{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.dev.lang.nix;
in {
  options.dev.lang.nix = with lib; {
    enable = (mkEnableOption "Nix language") // { default = true; };
  };
  imports = [
    ./nix/templates.nix
  ];
  config = lib.mkIf (config.dev.enable && cfg.enable) {
    home.packages = with pkgs; [
      statix
      alejandra
      rnix-lsp
    ];
    programs.jq.enable = true;
  };
}
