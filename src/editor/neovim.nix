{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.desktop.editor;
  nvm = cfg.neovim;
in {
  options.signal.desktop.editor.neovim = with lib; {
    enable = (mkEnableOption "neovim GUI") // {default = config.signal.dev.editor.neovim.enable or false;};
    package = mkOption {
      type = types.package;
      default =
        if config.system.isNixOS
        then pkgs.neovide
        else lib.signal.home.linkSystemApp pkgs {app = "neovide";};
    };
  };
  disabledModules = [];
  imports = [];
  config = lib.mkIf (cfg.enable && nvm.enable) (lib.mkMerge [
    {
      home.packages = [nvm.package];
      xdg.desktopEntries = {
        neovide-multigrid = {
          type = "Application";
          exec = "neovide --multigrid %F";
          name = "Neovide (nvim) (multigrid)";
          icon = "nvim";
          comment = "No Nonsense Neovim Client in Rust (with custom launch flags)";
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
            Keywords = "Text;Editor;nvim;Neovim";
          };
        };
      };
    }
  ]);
  meta = {};
}
