{
  config,
  pkgs,
  lib,
  ...
}:
let
  direnv = config.programs.direnv;
in
{
  config = {
    home.packages = [
      pkgs.devenv
    ];
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      # NOTE :: this is read-only; fish automatically loads the direnv module regardless of this option
      # enableFishIntegration = config.programs.fish.enable;
      enableZshIntegration = config.programs.zsh.enable;
      nix-direnv.enable = true;
    };
    xdg.configFile = lib.mkIf direnv.enable {
      "direnv/direnvrc" = {
        text = ''
        # strict_env

        : ''${XDG_RUNTIME_DIR:=/run/user/$UID}
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
            local hash path
            echo "''${direnv_layout_dirs[$PWD]:=$(
                hash="$(sha1sum - <<< "$PWD" | head -c40)"
                path="''${PWD//[^a-zA-Z0-9]/-}"
                echo "''${XDG_RUNTIME_DIR}/direnv/layouts/''${hash}''${path}"
            )}"
        }
        '';
        executable = true;
      };
    };
  };
}
