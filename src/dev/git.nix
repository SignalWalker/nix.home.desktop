{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.dev.lang.haskell;
in {
  options.dev.git = with lib; {
    enable = (mkEnableOption "Git configuration") // { default = true; };
  };
  imports = [];
  config = lib.mkIf (config.dev.enable && cfg.enable) {
    home.packages = with pkgs; [
      gitoxide
      gh
      glab
    ];
    programs.git = {
      enable = true;
      userName = "Ash Walker";
      userEmail = config.accounts.email.accounts.primary.address;
      lfs.enable = true;
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
