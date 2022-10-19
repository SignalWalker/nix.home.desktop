{ config
, pkgs
, lib
, ...
}:
with builtins; let
  std = pkgs.lib;
in
{
  options = with lib; { };
  imports = [ ];
  config = {
    home.packages = with pkgs; [
      discord-canary
      element-desktop
    ];
    signal.desktop.wayland.compositor.scratchpads = [
      { kb = "Shift+D"; criteria = { class = "discord"; }; resize = 93; startup = "discordcanary"; }
      { kb = "Shift+M"; criteria = { class = "Element"; }; resize = 93; startup = "element-desktop"; }
      { kb = "Shift+I"; criteria = { app_id = "scratch_irc"; }; resize = 83; startup = "kitty --class scratch_irc weechat"; }
    ];
  };
}
