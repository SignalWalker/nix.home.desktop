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
    in {
      formatter = std.mapAttrs (system: pkgs: pkgs.default) inputs.alejandra.packages;
      signalModules.default = {
        name = "home.desktop.default";
        dependencies =
          (hlib.signal.dependency.default.fromInputs {
            inherit inputs;
            filter = ["homelib" "ash-scripts" "polybar-scripts" "wired"];
          })
          // {
            mozilla = {
              input = inputs.mozilla;
              outputs.overlays = ["firefox"];
            };
          };
        outputs = dependencies: {
          homeManagerModules.default = {lib, ...}: {
            options.signal.desktop.flakeInputs = with lib;
              mkOption {
                type = types.attrsOf types.anything;
                default = dependencies;
              };
            imports = [
              ./home-manager.nix
            ];
            config = {};
          };
        };
      };
      homeConfigurations = home.genConfigurations self;
      packages = home.genActivationPackages self.homeConfigurations;
      apps = home.genActivationApps self.homeConfigurations;
      # homeConfigurations =
      #   mapAttrs (system: pkgs: let
      #     extraMod = {pkgs, ...}: {
      #       config.programs.firefox.package = pkgs.latest.firefox-nightly-bin;
      #     };
      #   in {
      #     default = hlib.genHomeConfiguration {
      #       inherit pkgs;
      #       modules = [self.homeManagerModules.default extraMod];
      #     };
      #     with-x11 = hlib.genHomeConfiguration {
      #       inherit pkgs;
      #       modules = [
      #         self.homeManagerModules.default
      #         extraMod
      #         ({...}: {
      #           config.signal.desktop.x11.enable = true;
      #         })
      #       ];
      #     };
      #   })
      #   nixpkgsFor;
      # packages = hlib.genHomeActivationPackages self.homeConfigurations;
      # apps = hlib.genHomeActivationApps self.homeConfigurations;
    };
}
