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
      pname = "package";
    in
    {
      formatter = lib.mapAttrs (system: pkgs: pkgs.nixfmt) nixpkgsFor;
      packages = lib.mapAttrs (
        system: pkgs:
        let
          stdenv = makeStdenv pkgs;
        in
        {
          ${pname} = stdenv.mkDerivation {
            inherit pname;
            src = ./.;
          };
          default = self.packages.${system}.${pname};
        }
      ) nixpkgsFor;
      devShells = lib.mapAttrs (
        system: pkgs:
        let
          selfPkgs = self.packages.${system};
          stdenv = makeStdenv pkgs;
        in
        {
          default = (pkgs.mkShell.override { inherit stdenv; }) {
            inputsFrom = [ selfPkgs.default ];
          };
        }
      ) nixpkgsFor;
    };
}
