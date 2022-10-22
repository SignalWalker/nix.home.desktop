{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.kvm;
in {
  options.signal.desktop.kvm = with lib; {
    enable = (mkEnableOption "kvm") // {default = true;};
  };
  imports = lib.signal.fs.path.listFilePaths ./kvm;
  config = lib.mkIf cfg.enable {
    services.input-leap = {
      package = lib.signal.home.linkSystemApp pkgs {app = "barriers";};
      server.enable = true;
    };
  };
}
