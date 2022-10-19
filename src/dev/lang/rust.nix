{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.dev.lang.rust;
  toml = pkgs.formats.toml {};
in {
  options.signal.dev.lang.rust = with lib; {
    enable = (mkEnableOption "Rust language") // {default = true;};
    rustup = {
      home = mkOption {
        type = types.str;
        default = "${config.xdg.dataHome}/rustup";
      };
    };
    cargo = {
      home = mkOption {
        type = types.str;
        default = "${config.xdg.dataHome}/cargo";
      };
      config = mkOption {
        type = toml.type;
        default = {};
      };
      linker = mkOption {
        type = types.str;
        default = "lld";
      };
    };
  };
  imports = [];
  config = lib.mkIf (cfg.enable) {
    systemd.user.sessionVariables = {
      RUSTUP_HOME = cfg.rustup.home;
      CARGO_HOME = cfg.cargo.home;
      RUSTC_LD = cfg.cargo.linker; # meson
    };
    home.packages = with pkgs; [
      # rustup
      # config.signal.dev.lang.c.llvmPackages.clang
      # latest.rustChannels.nightly.rustup
    ];
    home.sessionPath = ["${cfg.cargo.home}/bin"];
    home.file."${cfg.cargo.home}/config.toml" = {
      source = toml.generate "config.toml" cfg.cargo.config;
    };
    signal.dev.lang.rust.cargo.config = {
      target."x86_64-unknown-linux-gnu" = {
        linker = "clang";
        rustflags = ["-Clink-arg=-fuse-ld=${cfg.cargo.linker}"]; # "-Zshare-generics=y"
      };
      profile."release" = {
        lto = true;
      };
    };
  };
}
