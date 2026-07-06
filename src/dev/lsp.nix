{
  lib,
  ...
}:
{
  imports = lib.listFilePaths ./lsp;
  config = {
    services.lspmux = {
      enable = false;
      settings = {
        pass_environment = [
          "*"
          "!KITTY_*"
          "!XCURSOR_*"
          "!STARSHIP_*"
          "!ATUIN_*"
          "!OLDPWD"
          "!DIRENV_DIR"
          "!LS_COLORS"
          "!NVIM"
        ];
      };
    };
  };
  meta = { };
}
