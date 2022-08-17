{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.services.wayland.compositor;
in {
  options.services.wayland.compositor = with lib; {};
  imports = [
    ./compositor/hyprland.nix
    ./compositor/river.nix
    ./compositor/sway.nix
  ];
  config = {};
}
