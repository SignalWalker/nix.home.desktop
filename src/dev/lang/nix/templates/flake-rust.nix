{
  description = "";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    crane = {
      url = "github:ipetkov/crane";
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
  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    with builtins;
    let
      std = nixpkgs.lib;

      systems = attrNames inputs.crane.packages;
      nixpkgsFor = std.genAttrs systems (
        system:
        import nixpkgs {
          localSystem = builtins.currentSystem or system;
          crossSystem = system;
          overlays = [ inputs.rust-overlay.overlays.default ];
        }
      );

      toolchainToml = fromTOML (readFile ./rust-toolchain.toml);
      toolchainFor = std.mapAttrs (
        system: pkgs: pkgs.rust-bin.fromRustupToolchain toolchainToml.toolchain
      ) nixpkgsFor;

      craneFor = std.mapAttrs (
        system: pkgs: (inputs.crane.mkLib pkgs).overrideToolchain toolchainFor.${system}
      ) nixpkgsFor;

      makeStdenv = pkgs: pkgs.stdenvAdapters.useMoldLinker pkgs.llvmPackages_latest.stdenv;

      commonArgsFor = std.mapAttrs (
        system: pkgs:
        let
          crane = craneFor.${system};
        in
        {
          src = crane.cleanCargoSource (crane.path ./.);
          stdenv = makeStdenv;
          strictDeps = true;
          nativeBuildInputs = [ ];
          buildInputs = [ ];
        }
      ) nixpkgsFor;

      cargoToml = fromTOML (readFile ./Cargo.toml);
      name =
        cargoToml.package.metadata.crane.name or cargoToml.package.name
          or cargoToml.workspace.metadata.crane.name;
      version = cargoToml.package.version or cargoToml.workspace.package.version;

      makeMeta = lib: {
        description = cargoToml.package.description or null;
        homepage = cargoToml.package.repository or null;
        license = cargoToml.package.license or [ ];
        sourceProvenance = [ lib.sourceTypes.fromSource ];
        mainProgram = name;
        platforms = [ lib.platforms.linux ];
        maintainers = [
          {
            name = "Ash Walker";
            email = "ashurstwalker@gmail.com";
            github = "SignalWalker";
            githubId = 7883605;
            keys = [ { fingerprint = "501A A952 63CF 564B 5E08 26A9 893F FE5C 7CDA 81A3"; } ];
          }
        ];
      };
    in
    {
      formatter = std.mapAttrs (system: pkgs: pkgs.nixfmt-rfc-style) nixpkgsFor;
      packages = std.mapAttrs (
        system: pkgs:
        let
          crane = craneFor.${system};
          commonArgs = commonArgsFor.${system};
          meta = makeMeta pkgs.lib;
        in
        {
          default = self.packages.${system}.${name};
          "${name}-artifacts" = crane.buildDepsOnly commonArgs;
          ${name} = crane.buildPackage (
            commonArgs
            // {
              cargoArtifacts = self.packages.${system}."${name}-artifacts";
              inherit meta;
            }
          );
        }
      ) nixpkgsFor;
      checks = std.mapAttrs (
        system: pkgs:
        let
          crane = craneFor.${system};
          commonArgs = commonArgsFor.${system};
          cargoArtifacts = self.packages.${system}."${name}-artifacts";
        in
        {
          ${name} = pkgs.${name};
          "${name}-clippy" = crane.cargoClippy (
            commonArgs
            // {
              inherit cargoArtifacts;
            }
          );
          "${name}-coverage" = crane.cargoTarpaulin (
            commonArgs
            // {
              inherit cargoArtifacts;
            }
          );
          "${name}-audit" = crane.cargoAudit (
            commonArgs
            // {
              pname = name;
              inherit version;
              inherit cargoArtifacts;
              advisory-db = inputs.advisory-db;
            }
          );
          "${name}-deny" = crane.cargoDeny (
            commonArgs
            // {
              inherit cargoArtifacts;
            }
          );
        }
      ) self.packages;
      apps = std.mapAttrs (system: pkgs: {
        ${name} = {
          type = "app";
          program = "${pkgs.${name}}/bin/${pkgs.${name}.meta.mainProgram}";
        };
        default = self.apps.${system}.${name};
      }) self.packages;
      devShells = std.mapAttrs (
        system: pkgs:
        let
          selfPkgs = self.packages.${system};
          toolchain = toolchainFor.${system}.override {
            extensions = [
              "rust-src"
              "rust-analyzer"
              "rustfmt"
              "clippy"
            ];
          };
          crane = (inputs.crane.mkLib pkgs).overrideToolchain toolchain;
          stdenv = makeStdenv pkgs;
        in
        {
          ${name} = (pkgs.mkShell.override { inherit stdenv; }) {
            inputsFrom = (attrValues self.checks.${system}) ++ [ selfPkgs.${name} ];
            packages = [
              toolchain
            ]
            ++ (with pkgs; [
              cargo-audit
              cargo-license
              cargo-dist
            ]);
            shellHook =
              let
                extraLdPaths = pkgs.lib.makeLibraryPath (
                  with pkgs;
                  [
                  ]
                );
              in
              ''
                export LD_LIBRARY_PATH="${extraLdPaths}:$LD_LIBRARY_PATH"
              '';
            env = {
            };
          };
          default = self.devShells.${system}.${name};
        }
      ) nixpkgsFor;
    };
}
