{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = {
    # programs.ironbar = {
    #   enable = false;
    #   config = {
    #     position = "top";
    #     start = [
    #       {
    #         type = "workspaces";
    #       }
    #       {type = "tray";}
    #       {
    #         type = "music";
    #         player_type = "mpris";
    #       }
    #     ];
    #     center = [
    #       {type = "focused";}
    #     ];
    #     end = [
    #       {type = "clipboard";}
    #       {
    #         type = "upower";
    #         format = "{percentage}%";
    #       }
    #       {type = "clock";}
    #     ];
    #   };
    #   style = "";
    #   systemd = false;
    # };
  };
  meta = {};
}
