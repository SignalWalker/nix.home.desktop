{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.dev.lang.c;
in {
  options.signal.dev.lang.c = with lib; {
    enable = (mkEnableOption "C/C++ language family") // {default = true;};
    llvmPackages = mkOption {
      type = types.attrsOf types.anything;
      default = pkgs.llvmPackages_latest;
    };
    linker = mkOption {
      type = types.str;
      default = "lld";
    };
  };
  imports = [];
  config = lib.mkIf (cfg.enable) {
    home.packages =
      [
        # cfg.llvmPackages.clang
        cfg.llvmPackages.clang-manpages
        cfg.llvmPackages.clang-tools
        # cfg.llvmPackages.bintools
      ]
      ++ (with pkgs; [
        cmake
        cmake-format
        cmake-language-server
        ninja
      ]);
    systemd.user.sessionVariables = {
      # CC = "clang";
      # CXX = "clang++";
      CMAKE_EXPORT_COMPILE_COMMANDS = "ON";
      # LDFLAGS = "-fuse-ld=${cfg.linker}";
      # CC_LD = cfg.linker; # meson
      # CXX_LD = cfg.linker; # meson
    };
  };
}
