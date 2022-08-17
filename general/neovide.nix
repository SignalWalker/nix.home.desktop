{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  imports = utils.listNix ./dev;
  config = {
    home.packages =
      (with pkgs; [
      ])
      ++ (std.optionals (!(config.home.impure or false)) [
        pkgs.neovide
      ]);
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
  };
}
