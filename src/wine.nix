{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = {
    home.packages = [ pkgs.bottles ];
    xdg.binFile."wine-bottles" = {
      executable = true;
      text = ''
        #! ${pkgs.zsh}/bin/zsh
        bottles-cli run -b Standard -e "$@"
      '';
    };
  };
  meta = { };
}
