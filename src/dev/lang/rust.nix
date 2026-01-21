{
  config,
  pkgs,
  lib,
  ...
}:
let
  rustup = config.programs.rustup;
  cargo = config.programs.cargo;
  toml = pkgs.formats.toml { };
in
{
  options = {
    programs.rustup = {
      enable = lib.mkEnableOption "rustup";
      package = lib.mkPackageOption pkgs "rustup" { };
      home = lib.mkOption {
        type = lib.types.str;
        default = "${config.xdg.dataHome}/rustup";
      };
    };
    programs.cargo = {
      enable = lib.mkEnableOption "cargo";
      home = lib.mkOption {
        type = lib.types.str;
        default = "${config.xdg.dataHome}/cargo";
      };
      config = lib.mkOption {
        type = toml.type;
        default = { };
      };
    };
  };
  imports = [ ];
  disabledModules = [
    "programs/cargo.nix"
  ];
  config = lib.mkMerge [
    {
      programs.rustup = {
        enable = true;
      };
      programs.cargo = {
        enable = true;
      };
    }
    (lib.mkIf rustup.enable {
      home.packages = [
        # rustup.package
      ];
      systemd.user.sessionVariables = {
        RUSTUP_HOME = rustup.home;
      };
    })
    (lib.mkIf cargo.enable {
      systemd.user.sessionVariables = {
        CARGO_HOME = cargo.home;
      };
      home.sessionPath = [ "${cargo.home}/bin" ];
      home.file."${cargo.home}/config.toml" = {
        source = toml.generate "config.toml" cargo.config;
      };
    })
  ];
}
