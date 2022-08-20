{
  description = "Home manager configuration - graphical desktop";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    alejandra = {
      url = github:kamadorueda/alejandra;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homebase = {
      url = github:signalwalker/nix.home.base;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.alejandra.follows = "alejandra";
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
      homelib = inputs.homebase.inputs.homelib;
      std = nixpkgs.lib;
      hlib = homelib.lib;
      nixpkgsFor = hlib.genNixpkgsFor {
        inherit nixpkgs;
        overlays = [ inputs.mozilla.overlays.firefox ];
      };
    in {
      formatter = std.mapAttrs (system: pkgs: pkgs.default) inputs.alejandra.packages;
      homeManagerModules.default = {lib, ...}: {
        options.signal.desktop.flakeInputs = with lib;
          mkOption {
            type = types.attrsOf types.anything;
            default = inputs;
          };
        imports =
          [
            ./home-manager.nix
          ]
          ++ (hlib.collectInputModules (attrValues (removeAttrs inputs ["self" "polybar-scripts"])));
        config = {};
      };
      homeConfigurations =
        mapAttrs (system: pkgs: let
          extraMod = { pkgs, ... }: {
            config.programs.firefox.package = pkgs.latest.firefox-nightly-bin;
          };
        in {
          default = hlib.genHomeConfiguration {
            inherit pkgs;
            modules = [self.homeManagerModules.default extraMod];
          };
          with-x11 = hlib.genHomeConfiguration {
            inherit pkgs;
            modules = [
              self.homeManagerModules.default
              extraMod
              ({...}: {
                config.signal.desktop.x11.enable = true;
              })
            ];
          };
        })
        nixpkgsFor;
      packages = hlib.genHomeActivationPackages self.homeConfigurations;
      apps = hlib.genHomeActivationApps self.homeConfigurations;
    };
}
