{
  ...
}:
{
  config = {
    xdg.userDirs.templateFile = {
      "nix/module.nix".source = ./templates/module.nix;
      "nix/flake.nix".source = ./templates/flake.nix;
      "nix/flake-rust.nix".source = ./templates/flake-rust.nix;
      "nix/flake-python.nix".source = ./templates/flake-python.nix;
    };
  };
}
