{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.dev.cache;
in {
  options.dev.cache = with lib; {
    enable = mkEnableOption "global caching for C/C++/Rust compiler artifacts";
    cache = {
      path = mkOption {
        type = types.str;
        default = "${config.xdg.cacheHome}/sccache";
      };
      maxSize = mkOption {
        type = types.str;
        default = "16G";
      };
    };
  };
  imports = [];
  config = lib.mkIf (config.dev.enable && cfg.enable) {
    home.packages = with pkgs; [
      sccache
    ];
    dev.lang.rust.cargo.config.build.rustc-wrapper = "sccache";
    systemd.user.sessionVariables = lib.mkMerge [
      {
        SCCACHE_DIR = cfg.cache.path;
        SCCACHE_CACHE_SIZE = cfg.cache.maxSize;
      }
      (lib.mkIf config.dev.lang.c.enable {
        CMAKE_C_COMPILER_LAUNCHER = "sccache";
        CMAKE_CXX_COMPILER_LAUNCHER = "sccache";
      })
    ];
  };
}
