{
  description = "";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    crane = {
      url = "github:ipetkov/crane";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {
        imports = [ ];
        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
          "x86_64-darwin"
        ];
        flake = {

        };
        perSystem =
          let
            toolchainToml = builtins.fromTOML (builtins.readFile ./rust-toolchain.toml);
            cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
            pkgName =
              cargoToml.package.metadata.crane.name or cargoToml.package.name
                or cargoToml.workspace.metadata.crane.name;
            # pkgVersion = cargoToml.package.version or cargoToml.workspace.package.version;
            # use mold & llvm by default
            makeStdenv = pkgs: pkgs.stdenvAdapters.useMoldLinker pkgs.llvmPackages_latest.stdenv;
          in
          {
            # self but with the current system flattened (i.e. self.packages.${system}.foo == self'.packages.foo)
            self',
            pkgs,
            system,
            ...
          }:
          let
            baseToolchain = pkgs.rust-bin.fromRustupToolchain toolchainToml.toolchain;
          in
          {
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [
                inputs.rust-overlay.overlays.default
              ];
            };

            formatter = pkgs.nixfmt;

            packages =
              let
                crane = (inputs.crane.mkLib pkgs).overrideToolchain baseToolchain;
                commonArgs = {
                  src = crane.cleanCargoSource (crane.path ./.);
                  stdenv = makeStdenv;
                  strictDeps = true;
                  nativeBuildInputs = [ ];
                  buildInputs = [ ];
                };
              in
              {
                default = self'.packages.${pkgName};
                "${pkgName}-artifacts" = crane.buildDepsOnly commonArgs;
                ${pkgName} = crane.buildPackage (
                  commonArgs
                  // {
                    cargoArtifacts = self'.packages."${pkgName}-artifacts";
                    meta = {
                      description = cargoToml.package.description or "";
                      homepage = cargoToml.package.repository or null;
                      license = cargoToml.package.license or [ ];
                      sourceProvenance = [ lib.sourceTypes.fromSource ];
                      mainProgram = pkgName;
                      platforms = lib.platforms.all;
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
                  }
                );
              };

            devShells = {
              default = self'.devShells.${pkgName};
              ${pkgName} = (pkgs.mkShell.override { stdenv = makeStdenv pkgs; }) (
                let
                  shellToolchain = pkgs.rust-bin.selectLatestNightlyWith (
                    toolchain:
                    toolchain.default.override {
                      extensions = lib.lists.uniqueStrings (
                        baseToolchain.extensions
                        ++ [
                          "rust-src"
                          "rust-analyzer"
                          "rustfmt"
                          "clippy"
                        ]
                      );
                    }
                  );
                in
                {
                  inputsFrom = [ self'.packages.${pkgName} ];
                  packages = [
                    shellToolchain

                    pkgs.cargo-audit
                    pkgs.cargo-license
                    pkgs.cargo-dist

                    pkgs.cargo-limit
                    pkgs.cargo-expand
                    pkgs.cargo-watch
                    pkgs.cargo-cache
                  ];
                  shellHook =
                    let
                      ldPaths = lib.makeLibraryPath [
                      ];
                    in
                    ''
                      export LD_LIBRARY_PATH="${ldPaths}:$LD_LIBRARY_PATH"
                    '';
                  env = {
                    RUST_BACKTRACE = 1;
                  };
                }
              );
            };
          };
      }
    );
}
