{
  description = "";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }: {
        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
          "x86_64-darwin"
        ];
        perSystem =
          let
            pname = "package";
          in
          {
            self',
            pkgs,
            ...
          }:
          let
            stdenv = pkgs.stdenvAdapters.useMoldLinker pkgs.llvmPackages_latest.stdenv;
          in
          {
            formatter = pkgs.nixfmt;
            packages = {
              default = self'.packages.${pname};
              ${pname} = stdenv.mkDerivation {
                inherit pname;
                src = ./.;
              };
            };
            devShells = {
              default = self'.devShells.${pname};
              ${pname} = (pkgs.mkShell.override { inherit stdenv; }) {
                inputsFrom = [ self'.packages.${pname} ];
              };
            };
          };
      }
    );
}
