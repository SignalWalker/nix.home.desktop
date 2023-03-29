{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  ipfs = config.services.ipfs;
  json = pkgs.formats.json {};
in {
  options = with lib; {
    services.ipfs = {
      enable = (mkEnableOption "IPFS service") // {default = true;};
      package = mkOption {
        type = types.package;
        default = pkgs.kubo;
      };
      dirs = {
        dataName = mkOption {
          type = types.str;
          default = "ipfs";
        };
        data = mkOption {
          type = types.str;
          readOnly = true;
          default = "${config.xdg.dataHome}/${ipfs.dirs.dataName}";
        };
      };
      settings = mkOption {
        type = types.nullOr json.type;
        default = null;
      };
      settingsFile = mkOption {
        type = types.nullOr types.path;
        readOnly = true;
        default =
          if ipfs.settings != null
          then json.generate "config" ipfs.settings
          else null;
      };
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf ipfs.enable (lib.mkMerge [
    {
      home.packages = [ipfs.package];
      systemd.user.sessionVariables = {
        IPFS_PATH = ipfs.dirs.data;
      };
      systemd.user.sockets."ipfs-api" = {
        Unit = {
          Description = "IPFS API socket";
        };
        Socket = {
          Service = "ipfs.service";
          FileDescriptorName = "io.ipfs.api";
          BindIPv6Only = true;
          ListenStream = ["127.0.0.1:5001" "[::1]:5001"];
        };
        Install = {
          WantedBy = ["sockets.target"];
        };
      };
      systemd.user.sockets."ipfs-gateway" = {
        Unit = {
          Description = "IPFS gateway socket";
        };
        Socket = {
          Service = "ipfs.service";
          FileDescriptorName = "io.ipfs.gateway";
          BindIPv6Only = true;
          ListenStream = ["127.0.0.1:8080" "[::1]:8080"];
        };
        Install = {
          WantedBy = ["sockets.target"];
        };
      };
      systemd.user.services."ipfs" = {
        Unit = {
          Description = "IPFS daemon";
          After = ["network.target"];
        };
        Service = {
          Type = "notify";
          ExecStart = "${ipfs.package}/bin/ipfs daemon --migrate --enable-gc --enable-namesys-pubsub";
          Restart = "on-failure";
          TimeoutStartSec = "infinity";
          KillSignal = "SIGINT";
          Slice = "background.slice";
          # security
          ReadWritePaths = [ipfs.dirs.data];
          NoNewPrivileges = true;
          ProtectSystem = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          PrivateDevices = true;
          DevicePolicy = "closed";
          ProtectControlGroups = true;
          RestrictAddressFamilies = ["AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK"];
          ProtectHostname = true;
          PrivateTmp = true;
          ProtectClock = true;
          LockPersonality = true;
          RestrictNamespaces = true;
          RestrictRealtime = true;
          MemoryDenyWriteExecute = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = ["~@privileged" "@system-service"];
          ProtectHome = true;
          RemoveIPC = true;
          RestrictSUIDSGID = true;
          CapabilityBoundingSet = ["CAP_NET_BIND_SERVICE"];
          # performance
          MemorySwapMax = "0";
        };
      };
    }
    (lib.mkIf (ipfs.settings != null) {
      xdg.dataFile."ipfs/config" = {
        source = ipfs.settingsFile;
      };
    })
  ]);
  meta = {};
}
