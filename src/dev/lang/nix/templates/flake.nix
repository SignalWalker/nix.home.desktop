{
  description = "";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    alejandra = {
      url = "github:kamadorueda/alejandra";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }:
    with builtins; let
      std = nixpkgs.lib;
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      nixpkgsFor = std.genAttrs systems (system:
        import nixpkgs {
          localSystem = builtins.currentSystem or system;
          crossSystem = system;
          overlays = [];
        });
      stdenvFor = std.mapAttrs (system: pkgs: pkgs.stdenvAdapters.useMoldLinker pkgs.llvmPackages_latest.stdenv) nixpkgsFor;
    in {
      formatter = std.mapAttrs (system: pkgs: pkgs.default) inputs.alejandra.packages;
      packages =
        std.mapAttrs (system: pkgs: let
          std = pkgs.lib;
        in {
          default = stdenvFor.${system}.mkDerivation {
            src = ./.;
          };
        })
        nixpkgsFor;
      devShells =
        std.mapAttrs (system: pkgs: let
          selfPkgs = self.packages.${system};
        in {
          default = pkgs.mkShell {
            stdenv = stdenvFor.${system};
            inputsFrom = [selfPkgs.default];
          };
        })
        nixpkgsFor;
    };
}
