{
  description = "";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    let
      lib = nixpkgs.lib;
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      nixpkgsFor = lib.genAttrs systems (
        system:
        import nixpkgs {
          localSystem = builtins.currentSystem or system;
          crossSystem = system;
          overlays = [ ];
        }
      );
      makeStdenv = pkgs: pkgs.stdenvAdapters.useMoldLinker pkgs.llvmPackages_latest.stdenv;
      makePython = pkgs: pkgs.python3.withPackages (ps: [ ]);
    in
    {
      formatter = lib.mapAttrs (system: pkgs: pkgs.nixfmt) nixpkgsFor;
      devShells = lib.mapAttrs (
        system: pkgs:
        let
          selfPkgs = self.packages.${system};
          stdenv = makeStdenv pkgs;
          python = makePython pkgs;
        in
        {
          default = (pkgs.mkShell.override { inherit stdenv; }) {
            nativeBuildInputs = [
              python
              pkgs.uv
            ];
          };
        }
      ) nixpkgsFor;
    };
}
