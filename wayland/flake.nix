{
  description = "Home Manager module for wayland config";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    alejandra = {
      url = github:kamadorueda/alejandra;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = github:hyprwm/hyprland;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    hyprland,
    ...
  }:
    with builtins; let
      std = nixpkgs.lib;
    in {
      formatter = std.mapAttrs (system: pkgs: pkgs.default) inputs.alejandra.packages;
      homeManagerModules.default = import ./home-manager.nix inputs;
    };
}
