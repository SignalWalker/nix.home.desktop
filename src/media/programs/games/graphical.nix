{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  imports = [];
  config = let
    roms = [
      "Super Mario 64 (USA)"
      "Legend of Zelda, The - Ocarina of Time (USA)"
      "Legend of Zelda, The - Majora's Mask (USA)"
      "Banjo-Kazooie (USA)"
      "Mischief Makers (USA)"
    ];
  in {
    home.packages = with pkgs; [
      mgba
    ];
    # programs.modloader64-gui = {
    #   enable = true;
    #   cores = attrValues pkgs.modloader64.cores;
    #   mods = attrValues pkgs.modloader64.mods;
    #   roms = [];
    #   # map
    #   # (rom:
    #   #   pkgs.runCommandLocal "${rom}.z64"
    #   #   {
    #   #     nativeBuildInputs = with pkgs; [p7zip];
    #   #     downloadedFile = pkgs."nointro.n64"."${rom}.7z";
    #   #   }
    #   #   ''
    #   #     echo "Extracting $downloadedFile to $out..."
    #   #     7z e $downloadedFile -so > $out
    #   #   '')
    #   # roms;
    #   config = {
    #     showAdvancedTab = true;
    #   };
    # };
  };
}
