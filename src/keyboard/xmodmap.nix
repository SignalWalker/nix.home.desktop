{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options.services.X11.xmodmap = with lib; {
    enable = mkEnableOption "xmodmap";
    outputPath = mkOption {
      type = types.str;
      default = ".config/xmodmap";
    };
    settings = mkOption {
      type = types.lines;
      default = "";
    };
  };
  imports = [];
  config = let
    cfg = config.services.X11.xmodmap;
  in
    lib.mkIf cfg.enable {
      home.file.${cfg.outputPath}.text = cfg.settings;
      systemd.user.services."xmodmap" = {
        Unit.Description = "Modify xmodmap";
        Unit.After = ["setxkbmap.service"];
        Unit.PartOf = ["setxkbmap.service"];
        Install.WantedBy = ["setxkbmap.service"];
        Service.Type = "oneshot";
        Service.RemainAfterExit = true;
        Service.ExecStart = "${pkgs.xorg.xmodmap}/bin/xmodmap %h/${cfg.outputPath}";
      };
    };
}
