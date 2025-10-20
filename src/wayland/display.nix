{
  ...
}:
{
  config = {
    home.packages = [
      # pkgs.nwg-displays # GUI output management
    ];
    services.shikane = {
      enable = true;
      settings = {
        profile = [
          {
            name = "builtin-only";
            output = [
              {
                match = "eDP-1";
                enable = true;
              }
            ];
          }
        ];
      };
    };
  };
  meta = { };
}
