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

      toolchainToml = fromTOML (readFile ./rust-toolchain.toml);
      name = (fromTOML (readFile ./Cargo.toml)).package.name;
    in {
      formatter = std.mapAttrs (system: pkgs: pkgs.default) inputs.alejandra.packages;
      packages =
        std.mapAttrs (system: pkgs: let
          toolchain = pkgs.rust-bin.fromRustupToolchain toolchainToml.toolchain;
          crane = (inputs.crane.mkLib pkgs).overrideToolchain toolchain;
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
      checks =
        std.mapAttrs (system: pkgs: {
          ${name} = pkgs.${name};
        })
        self.packages;
      apps =
        std.mapAttrs (system: pkgs: {
          ${name} = {
            type = "app";
            program = "${pkgs.${name}}/bin/${name}";
          };
          default = self.apps.${system}.${name};
        })
        self.packages;
      devShells =
        std.mapAttrs (system: pkgs: let
          selfPkgs = self.packages.${system};
          toolchain = (pkgs.rust-bin.fromRustupToolchain toolchainToml.toolchain).override {
            extensions = [
              "rust-analyzer"
              "rustfmt"
              "clippy"
            ];
          };
          crane = (inputs.crane.mkLib pkgs).overrideToolchain toolchain;
        in {
          ${name} = crane.devShell {
            checks = self.checks.${system};
            packages = [];
          };
          default = self.devShells.${system}.${name};
        })
        nixpkgsFor;
    };
}
