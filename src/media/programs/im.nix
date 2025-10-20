{
  lib,
  ...
}:
{
  imports = lib.listFilePaths ./im;
  config = {
    # home.packages = [
    #   pkgs.slack
    # ];
    # desktop.scratchpads = {
    #   "Shift+S" = {
    #     criteria = {
    #       app_id = "Slack";
    #     };
    #     resize = 93;
    #     startup = "slack";
    #     systemdCat = true;
    #     automove = true;
    #   };
    # };
  };
}
