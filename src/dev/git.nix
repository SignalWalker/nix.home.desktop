{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.dev.git;
in {
  options.signal.dev.git = with lib; {
    enable = (mkEnableOption "Git configuration") // {default = true;};
  };
  imports = [];
  config = lib.mkIf (cfg.enable) {
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
      signing = {
        key = lib.mkDefault null;
        gpgPath =
          if config.programs.gpg.enable
          then "${config.programs.gpg.package}/bin/gpg"
          else "/usr/bin/gpg";
        signByDefault = true;
      };
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
