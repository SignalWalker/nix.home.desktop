inputs @ {
  config,
  pkgs,
  ...
}: {
  xresources = {
    path = "${config.xdg.configHome}/xresources";
    properties = {};
  };
}
