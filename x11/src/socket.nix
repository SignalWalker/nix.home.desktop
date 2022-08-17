{
  config,
  pkgs,
  utils,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  x11 = config.services.X11;
  sck = x11.socket;
in {
  options.services.X11.socket = {
    enable = lib.mkEnableOption "Xorg server systemd socket unit";
  };
  config = lib.mkIf (x11.enable && sck.enable) {
    systemd.user.sockets."xorg@" = {
      Unit.Description = "Socket for Xorg at display %i";
      Socket.ListenStream = "%t/xorg/X%i";
    };
    systemd.user.services."xorg@" = {
      Unit.Description = "Xorg server at display %i";
      Unit.Requires = "xorg@%i.socket";
      Unit.After = "xorg%i.socket";
      Service.Type = "simple";
      Service.SuccessExitStatus = "0 1";
      Service.ExecStart = "${pkgs.xorg.xorgserver}/bin/Xorg :%i -nolisten -noreset";
    };
  };
}
