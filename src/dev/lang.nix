{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.dev;
in {
  options = with lib; {};
  imports = [
    ./lang/c.nix
    ./lang/haskell.nix
    ./lang/js.nix
    ./lang/nix.nix
    ./lang/rust.nix
    ./lang/zig.nix
  ];
  config = lib.mkIf cfg.enable {};
}
