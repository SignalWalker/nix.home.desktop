{
  description = "Home manager configuration - graphical desktop";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    alejandra = {
      url = github:kamadorueda/alejandra;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homelib = {
      url = github:signalwalker/lib.home.nix;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.alejandra.follows = "alejandra";
    };
    homebase = {
      url = github:signalwalker/base.home.nix;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.alejandra.follows = "alejandra";
      inputs.homelib.follows = "homelib";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    homelib,
    ...
  }:
    with builtins; let
      std = nixpkgs.lib;
      hlib = homelib.lib;
      nixpkgsFor = hlib.genNixpkgsFor { inherit nixpkgs; overlays = []; };
    in {
      formatter = std.mapAttrs (system: pkgs: pkgs.default) inputs.alejandra.packages;
      homeManagerModules.default = { lib, ... }: {
        options = with lib; {};
        imports = [
          inputs.homebase.homeManagerModules.default
          ./home-manager.nix
        ];
        config = {
          home.stateVersion = stateVersion;
        };
      };
      homeConfigurations = mapAttrs (system: pkgs: {
        default = hlib.genHomeConfiguration {
          inherit pkgs inputs;
        };
      }) nixpkgsFor;
      packages = hlib.genHomeActivationPackages self.homeConfigurations;
      apps = hlib.genHomeActivationApps self.homeConfigurations;
    };
}
