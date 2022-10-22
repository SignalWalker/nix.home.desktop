{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.editor;
  hlx = cfg.helix;
  ed = config.signal.dev.editor.editors."helix";
in {
  options.signal.desktop.editor.helix = with lib; {
    enable = (mkEnableOption "helix GUI") // {default = config.signal.dev.editor.helix.enable or false;};
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf (cfg.enable && hlx.enable) {
    xdg.desktopEntries."helix" = {
      type = "Application";
      exec = "kitty --class helix ${ed.cmd.visual} %F";
      name = "Helix";
      icon = "hx";
      comment = "Helix text editor";
      categories = [
        "Utility"
        "TextEditor"
      ];
      mimeType = [
        "text/english"
        "text/plain"
        "text/x-makefile"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-c"
        "text/x-c++"
      ];
      settings = {
        Keywords = "Text;Editor;Helix;hx";
      };
    };
  };
  meta = {};
}
