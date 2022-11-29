{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf (config.signal.dev.lang.nix.enable) {
    xdg.userDirs.templateFile."module.nix".text = ''
      {
        config,
        pkgs,
        lib,
        ...
      }:
      with builtins; let
        std = pkgs.lib;
      in {
        options = with lib; {};
        disabledModules = [];
        imports = [];
        config = {};
        meta = {};
      }
    '';
    xdg.userDirs.templateFile."flake.nix".text = ''
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
          in {
            formatter = std.mapAttrs (system: pkgs: pkgs.default) inputs.alejandra.packages;
          };
      }
    '';
  };
}
