{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = {
    home.packages = lib.attrValues {
      inherit (pkgs)
        # debug
        strace
        ;
    };
  };
  meta = { };
}
