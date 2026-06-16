{
  ...
}:
{
  config = {
    desktop.windows = {
      floatWine = {
        criteria = {
          initialClass = ".*\\\\.exe$";
        };
        effects = {
          hypr.static.float = true;
        };
      };
    };
    # home.packages = [ pkgs.bottles ];
    # xdg.binFile."wine-bottles" = {
    #   executable = true;
    #   text = ''
    #     #! ${pkgs.zsh}/bin/zsh
    #     bottles-cli run -b Standard -e "$@"
    #   '';
    # };
  };
  meta = { };
}
