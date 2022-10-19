{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.services.input-leap;
  srv = cfg.server;
  cli = cfg.client;
in {
  options.services.input-leap = with lib; {
    package = mkOption {
      type = types.package;
    };
    server = {
      enable = mkEnableOption "input-leap kvm -- server";
      network.listen = {
        port = mkOption {
          type = types.int;
          default = 24800;
        };
        addr = mkOption {
          type = types.str;
          default = "[::]";
        };
      };
      systemd = {
        socket = {
          enable = (mkEnableOption "input-leap server socket") // { default = true; };
          target = mkOption {
            type = types.str;
            default = "graphical-session.target";
          };
        };
      };
    };
    client = {
      enable = mkEnableOption "input-leap kvm -- client";
    };
  };
  imports = [];
  config = lib.mkMerge [
    # both
    (lib.mkIf (srv.enable || cli.enable) {
      home.packages = [ cfg.package ];
    })
    # server
    (lib.mkIf srv.enable {
      systemd.user = lib.mkIf srv.systemd.socket.enable {
        services."input-leap-server" = {
          Unit = {
            Description = "Input-Leap KVM Server";
            PartOf = [ srv.systemd.socket.target ];
          };
          Service = {
            Type = "simple";
            ExecStart = "${cfg.package}/bin/barriers --no-restart --no-daemon";
          };
        };
        sockets."input-leap-server" = {
          Unit = {
            Description = "Input-Leap KVM Server";
            PartOf = [ srv.systemd.socket.target ];
          };
          Install = {
            WantedBy = [ srv.systemd.socket.target ];
          };
          Socket = {
            ListenStream = "${srv.network.listen.addr}:${toString srv.network.listen.port}";
            FreeBind = true;
            Accept = false;
          };
        };
      };
    })
    # client
    (lib.mkIf cli.enable {

    })
  ];
}
