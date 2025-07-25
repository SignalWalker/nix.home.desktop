{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
with builtins;
let
  std = pkgs.lib;
  cfg = config.signal.dev.git;
  crane = config.signal.dev.inputs.crane.lib.${pkgs.system};
  gnupg = osConfig.programs.gnupg or { };
  git = config.programs.git;
  jj = config.programs.jujutsu;
in
{
  options.signal.dev.git = with lib; {
    enable = (mkEnableOption "Git configuration") // {
      default = true;
    };
    onefetch = {
      src = mkOption {
        type = types.path;
      };
    };
  };
  imports = lib.listFilePaths ./git;
  config = lib.mkIf (cfg.enable) {
    programs.onefetch = {
      enable = false;
      # package = crane.buildPackage {
      #   src = crane.cleanCargoSource cfg.onefetch.src;
      #   nativeBuildInputs = with pkgs; [cmake installShellFiles pkg-config];
      #   buildInputs = with pkgs; [zstd];
      # };
    };
    home.packages = with pkgs; [
      # gitoxide
      gh
      glab
    ];
    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          name = git.userName;
          email = git.userEmail;
        };
        ui = {
          "default-command" = "status";
        };
        "merge-tool" = {
          # from https://github.com/rafikdraoui/jj-diffconflicts#invoking-through-jj-resolve
          "diffconflicts" = {
            program = "nvim";
            "merge-args" = [
              "-c"
              "let g:jj_diffconflicts_marker_length=$marker_length"
              "-c"
              "JJDiffConflicts!"
              "$output"
              "$base"
              "$left"
              "$right"
            ];
            "merge-tool-edits-conflict-markers" = true;
          };
        };
      };
    };
    # home.shellAliases = {
    #   gx = "gix"; # really don't like the default gitoxide command
    # };
    programs.git = {
      enable = true;
      userName = "Ash Walker";
      userEmail = config.signal.email.git;
      lfs.enable = true;
      signing = {
        key = lib.mkDefault null;
        signer = if (gnupg.agent.enable or false) then "${gnupg.package}/bin/gpg" else "/usr/bin/gpg";
        signByDefault = true;
      };
      ignores = [
        "/.lnvim.*"
        "/.envrc"
        "/.godot"
      ];
      extraConfig = {
        core = {
          autocrlf = "input";
        };
        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = true;
        };
        merge = {
          conflictStyle = "diff3";
        };
      };
    };
  };
}