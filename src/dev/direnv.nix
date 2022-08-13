{
  config,
  pkgs,
  lib,
  flakeInputs,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.dev;
in {
  options = with lib; {};
  imports = [];
  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      # enableFishIntegration = config.programs.fish.enable;
      enableZshIntegration = config.programs.zsh.enable;
      nix-direnv.enable = true;
    };
    xdg.configFile = lib.mkIf config.programs.direnv.enable {
      "direnv/direnvrc" = {
        text = ''
          # strict_env

          : ''${XDG_CACHE_HOME:=$HOME/.cache}
          declare -A direnv_layout_dirs
          direnv_layout_dir() {
              echo "''${direnv_layout_dirs[$PWD]:=$(
                  echo -n "$XDG_CACHE_HOME"/direnv/layouts/
                  echo -n "$PWD" | shasum | cut -d ' ' -f 1
              )}"
          }
        '';
        executable = true;
      };
    };
  };
}
