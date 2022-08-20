{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf (config.signal.dev.lang.nix.enable) {
    xdg.userDirs.templateFile."hm-module" = {
      text = ''
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
          imports = [];
          config = {};
        }
      '';
      target = "module.nix";
    };
    xdg.userDirs.templateFile."flake" = {
      text = ''
        {
          description = "";
          inputs = {
            nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
            alejandra = {
              url = github:kamadorueda/alejandra;
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
      target = "flake.nix";
    };
  };
}
