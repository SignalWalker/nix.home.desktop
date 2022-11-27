{
  description = "Home manager configuration - graphical desktop";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    alejandra = {
      url = github:kamadorueda/alejandra;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homelib = {
      url = github:signalwalker/nix.home.lib;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.alejandra.follows = "alejandra";
    };
    homebase = {
      url = github:signalwalker/nix.home.base;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.alejandra.follows = "alejandra";
      inputs.homelib.follows = "homelib";
    };
    # browser
    mozilla = {
      url = github:mozilla/nixpkgs-mozilla;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # services
    ash-scripts = {
      url = github:signalwalker/scripts-rs;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.mozilla.follows = "mozilla";
    };
    # x11
    polybar-scripts = {
      url = github:polybar/polybar-scripts;
      flake = false;
    };
    wired = {
      url = github:Toqozz/wired-notify;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # keyboard
    # xremap = {
    #   url = github:signalwalker/xremap;
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.alejandra.follows = "alejandra";
    # };
    # editor
    helixSrc = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "helix";
      flake = false;
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }:
    with builtins; let
      homelib = inputs.homelib;
      std = nixpkgs.lib;
      hlib = homelib.lib;
      home = hlib.home;
      signal = hlib.signal;
    in {
      formatter = std.mapAttrs (system: pkgs: pkgs.default) inputs.alejandra.packages;
      signalModules.default = {
        name = "home.desktop.default";
        dependencies = signal.flake.set.toDependencies {
          flakes = inputs;
          filter = ["alejandra"];
          outputs = {
            mozilla.overlays = ["firefox"];
          };
        };
        outputs = dependencies: {
          homeManagerModules = {lib, ...}: {
            imports = [
              ./home-manager.nix
            ];
            config = {
              signal.desktop.polybarScripts = dependencies.polybar-scripts;
              signal.desktop.editor.helix.src = inputs.helixSrc;
            };
          };
        };
      };
      homeConfigurations = home.configuration.fromFlake {
        flake = self;
        flakeName = "home.desktop";
      };
      packages = home.package.fromHomeConfigurations self.homeConfigurations;
      apps = home.app.fromHomeConfigurations self.homeConfigurations;
    };
}
