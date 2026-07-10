{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.signal.dev.editor;
  hlx = cfg.helix;
in
{
  options.signal.dev.editor.helix =
    let
      inherit (lib) mkEnableOption;
    in
    {
      enable = (mkEnableOption "helix text editor") // {
        default = true;
      };
    };
  disabledModules = [ ];
  imports = [ ];
  config = lib.mkIf (cfg.enable && hlx.enable) {
    signal.dev.editor.editors."helix" = {
      cmd.term = "hx";
    };
    programs.helix = {
      enable = hlx.enable;
      package = pkgs.helix;
      languages = {
        rust = {
          auto-format = true;
        };
      };
      settings = { };
      themes = { };
    };
  };
  meta = { };
}
