{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.dev.lang.nix;
in {
  options.signal.dev.lang.nix = with lib; {
    enable = (mkEnableOption "Nix language") // {default = true;};
  };
  imports = lib.signal.fs.path.listFilePaths ./nix;
  config = lib.mkIf (cfg.enable) {
    home.packages = with pkgs; [
      statix
      alejandra
      rnix-lsp
      agenix
    ];
    programs.jq.enable = true;
  };
}
