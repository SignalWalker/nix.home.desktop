{colors, ...}: {
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  dcfg = config.signal.desktop;
  cfg = config.signal.desktop.x11;
  tcfg = cfg.taskbar;
  tlib = config.lib.signal.types;
  dlib = config.lib.signal.desktop;
  std = pkgs.lib;
  baseBar = {
    enable-ipc = true;
    width = "100%";
    height = 13;
    fixed-center = true;
    inherit (colors) background foreground;
    line-size = 0;
    line-color = "#f00";
    border-size = 0;
    border-color = "#00000000";
    padding-left = 0;
    padding-right = 0;
    module-margin-left = 1;
    module-margin-right = 0;
    cursor-click = "pointer";
    cursor-scroll = "ns-resize";
    tray-padding = 0;
    tray-maxsize = 8;
    font = let
      toPattern = dlib.theme.fontToFcPattern;
      toInst = dlib.theme.fontToInst;
      toInsts = fontBases: opts: map (font: toInst font opts) fontBases;
      fonts = dcfg.theme.font;
      bmp = dlib.theme.bmpFcPatterns;
    in
    (dlib.theme.bmpPatternsIn [ 13 10 ]) ++ (foldl' (acc: fontSet: acc ++ (map toPattern fontSet)) [] [
      (toInsts fonts.mono { pixelsize = 13; })
      (toInsts fonts.symbols { pixelsize = 10; })
    ]);
  };
in
  std.mapAttrs' (bar: settings: std.nameValuePair "bar/${bar}" (std.recursiveUpdate baseBar settings)) {
    primary = {
      monitor = "\${env:MONITOR:eDP}";
      tray-position = "right";
      modules-left = "ewmh pulseaudio player-mpris-tail";
      modules-center = "xwindow";
      modules-right = "bond-network wlan-essid filesystem cpu memory battery weather date calendar";
    };
    secondary = {
      monitor = "\${env:MONITOR:HDMI-1-0}";
      modules-left = "ewmh";
      modules-center = "xwindow";
      modules-right = "cpu memory battery date calendar";
    };
  }
