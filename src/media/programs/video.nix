{
  pkgs,
  ...
}:
{
  config = {
    home.packages = [
      # jellyfin-media-player
    ];

    programs.obs-studio = {
      enable = true;
      plugins = (
        builtins.attrValues {
          inherit (pkgs.obs-studio-plugins)
            wlrobs
            obs-pipewire-audio-capture
            obs-vkcapture
            ;
        }
      );
    };

    services.jellyfin-mpv-shim = {
      enable = false;
    };

    desktop.windows = [
      {
        criteria = {
          app_id = "com.github.iwalton3.jellyfin-media-player";
        };
        inhibit_idle = "visible";
      }
    ];
  };
  meta = { };
}
