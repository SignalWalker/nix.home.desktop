{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options.signal.media.im = with lib; {};
  imports = lib.signal.fs.path.listFilePaths ./im;
  config = {
    programs.discord = {
      enable = true;
      vencord.enable = true;
      openasar.enable = true;
    };
    home.packages = with pkgs; [
      slack
    ];
    desktop.scratchpads = {
      "Shift+S" = {
        criteria = {
          app_id = "Slack";
        };
        resize = 93;
        startup = "slack";
        systemdCat = true;
        automove = true;
      };
    };
  };
}
