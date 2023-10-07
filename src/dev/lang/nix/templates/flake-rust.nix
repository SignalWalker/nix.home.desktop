{
  description = "";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    alejandra = {
      url = "github:kamadorueda/alejandra";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-analyzer-src.follows = "";
    };
    advisory-db = {
      url = "github:rustsec/advisory-db";
      flake = false;
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
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
      systems = attrNames inputs.crane.lib;
      nixpkgsFor = std.genAttrs systems (system:
        import nixpkgs {
          localSystem = builtins.currentSystem or system;
          crossSystem = system;
          overlays = [inputs.rust-overlay.overlays.default];
        });
      name = "package";
    in {
      formatter = std.mapAttrs (system: pkgs: pkgs.default) inputs.alejandra.packages;
      packages =
        std.mapAttrs (system: pkgs: let
          crane = (inputs.crane.mkLib pkgs).overrideToolchain (pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml);
          src = crane.cleanCargoSource (crane.path ./.);
          commonArgs = {
            inherit src;
            nativeBuildInputs = with pkgs; [
              llvmPackages_16.clang
              mold
            ];
          };
        in {
          default = self.packages.${system}.${name};
          "${name}-artifacts" = crane.buildDepsOnly commonArgs;
          ${name} = crane.buildPackage (commonArgs
            // {
              cargoArtifacts = self.packages.${system}."${name}-artifacts";
            });
        })
        nixpkgsFor;
      devShells =
        std.mapAttrs (system: selfPkgs: let
          pkgs = nixpkgsFor.${system};
        in {
          ${name} = pkgs.mkShell {
            inputsFrom = [selfPkgs.${name}];
          };
        })
        self.packages;
    };
}
