{
  description = "Home manager configuration - graphical desktop";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    alejandra = {
      url = github:kamadorueda/alejandra;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # browser
    mozilla = {
      url = github:mozilla/nixpkgs-mozilla;
    };
    # services
    watch-battery = {
      url = "git+https://git.ashwalker.net/ash/watch-battery";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # wayland
    yofi = {
      url = "github:l4l/yofi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## wallpaper
    swww = {
      url = "github:horus645/swww";
      flake = false;
    };
    # keyboard
    # xremap = {
    #   url = github:signalwalker/xremap;
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.alejandra.follows = "alejandra";
    # };
    # editor
    helixSrc = {
      # this is for the helix.desktop file
      url = "github:helix-editor/helix";
      flake = false;
    };
    # terminal
    kitty = {
      url = "github:kovidgoyal/kitty";
      flake = false;
    };
    # shell
    fishDone = {
      url = "github:franciscolourenco/done";
      flake = false;
    };
    # theme
    catppuccin-cava = {
      url = "github:catppuccin/cava";
      flake = false;
    };
    catppuccin-i3 = {
      url = "github:catppuccin/i3";
      flake = false;
    };
    tokyonight = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }:
    with builtins; let
      std = nixpkgs.lib;
    in {
      formatter = std.mapAttrs (system: pkgs: pkgs.default) inputs.alejandra.packages;
      homeManagerModules.default = {
        config,
        lib,
        pkgs,
        ...
      }: {
        imports = [
          inputs.watch-battery.homeManagerModules.default
          ./home-manager.nix
        ];
        config = {
          signal.desktop.editor.helix.src = inputs.helixSrc;

          programs.yofi.package = inputs.yofi.packages.${pkgs.system}.default;

          programs.fish.pluginSources = {
            done = inputs.fishDone;
          };

          desktop.wayland.wallpaper.swww.src = inputs.swww;

          desktop.theme.inputs = {
            cava = "${inputs.catppuccin-cava}/frappe.cava";
            i3 = "${inputs.catppuccin-i3}/themes/catppuccin-frappe";
            tokyonight = inputs.tokyonight;
          };
        };
      };
    };
}
