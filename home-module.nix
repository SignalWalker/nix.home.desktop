inputs:
{
  pkgs,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default

    # inputs.watch-battery.homeManagerModules.default
    inputs.ashvim.homeManagerModules.default
    inputs.lan-mouse.homeManagerModules.default
    inputs.nixcord.homeModules.default
    inputs.walker.homeManagerModules.default
    # inputs.stylix.homeModules.stylix
    ./home-manager.nix
  ];
  config = {

    # home.packages = [
    #   inputs.psysonic.packages.${pkgs.stdenv.hostPlatform.system}.psysonic
    # ];

    services.wallmaster.package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.wallmaster;

    home.file.".face" = {
      source = ./assets/avatar.png;
    };

    signal.desktop.editor.helix.src = inputs.helixSrc;
    programs.direnv.nix-direnv.package =
      inputs.nix-direnv.packages.${pkgs.stdenv.hostPlatform.system}.nix-direnv;

    # programs.yofi.package = inputs.yofi.packages.${pkgs.stdenv.hostPlatform.system}.default;

    programs.fish.pluginSources = {
      done = inputs.fishDone;
    };

    services.awww.package = inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww;

    desktop.theme.inputs = {
      cava = "${inputs.catppuccin-cava}/frappe.cava";
      i3 = "${inputs.catppuccin-i3}/themes/catppuccin-frappe";
      tokyonight = inputs.tokyonight;
      rose-pine-qt5ct = inputs.rose-pine-qt5ct;
    };

    programs.yazi.package = inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system}.default;

    programs.eww.package = inputs.eww.packages.${pkgs.stdenv.hostPlatform.system}.eww;

    # programs.quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;

  };
}
