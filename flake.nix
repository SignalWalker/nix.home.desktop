{
  description = "Home manager configuration - graphical desktop";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    alejandra = {
      url = "github:kamadorueda/alejandra";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # browser
    mozilla = {
      url = "github:mozilla/nixpkgs-mozilla";
    };
    firefox-nightly = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # services
    watch-battery = {
      url = "git+https://git.ashwalker.net/ash/watch-battery";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # wayland
    yofi = {
      type = "github";
      owner = "l4l";
      repo = "yofi";
      ref = "0.2.2";
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
    # HACK :: https://github.com/elkowar/eww/pull/1217
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    eww = {
      url = "github:elkowar/eww";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    # shikane = {
    #   url = "gitlab:w0lff/shikane";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # DEV
    nix-direnv = {
      url = "github:nix-community/nix-direnv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## editor
    ashvim = {
      url = "github:signalwalker/cfg.neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ashmacs = {
      url = "github:signalwalker/cfg.emacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    with builtins;
    let
      std = nixpkgs.lib;
    in
    {
      formatter = std.mapAttrs (system: pkgs: pkgs.default) inputs.alejandra.packages;
      homeManagerModules.default =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          imports = [
            inputs.watch-battery.homeManagerModules.default
            ./home-manager.nix
          ];
          config = {
            signal.desktop.editor.helix.src = inputs.helixSrc;
            programs.direnv.nix-direnv.package = inputs.nix-direnv.packages.${pkgs.system}.nix-direnv;

            # programs.yofi.package = inputs.yofi.packages.${pkgs.system}.default;

            programs.fish.pluginSources = {
              done = inputs.fishDone;
            };

            desktop.wayland.wallpaper.swww.src = inputs.swww;

            desktop.theme.inputs = {
              cava = "${inputs.catppuccin-cava}/frappe.cava";
              i3 = "${inputs.catppuccin-i3}/themes/catppuccin-frappe";
              tokyonight = inputs.tokyonight;
            };

            programs.eww.package = inputs.eww.packages.${pkgs.system}.eww;

            # programs.firefox.package = inputs.firefox-nightly.packages.${pkgs.system}.firefox-nightly-bin;
            programs.firefox.package = pkgs.firefox-devedition;
          };
        };
    };
}
