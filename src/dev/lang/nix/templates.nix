{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf (config.signal.dev.lang.nix.enable) {
    xdg.userDirs.templateFile."nix/module.nix".source = ./templates/module.nix;
    xdg.userDirs.templateFile."nix/flake.nix".source = ./templates/flake.nix;
    xdg.userDirs.templateFile."nix/flake-rust.nix".source = ./templates/flake-rust.nix;
    xdg.userDirs.templateFile."nix/flake-python.nix".source = ./templates/flake-python.nix;
  };
}
