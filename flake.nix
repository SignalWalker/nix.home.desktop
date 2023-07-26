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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # services
    ash-scripts = {
      url = "github:signalwalker/scripts-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.mozilla.follows = "mozilla";
    };
    # x11
    polybar-scripts = {
      url = github:polybar/polybar-scripts;
      flake = false;
    };
    wired = {
      url = github:Toqozz/wired-notify;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # wayland
    yofi = {
      url = "github:l4l/yofi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    waybarSrc = {
      url = "github:alexays/waybar";
      flake = false;
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
        ...
      }: {
        imports = [
          inputs.ash-scripts.homeManagerModules.default
          ./home-manager.nix
        ];
        config = {
          signal.desktop.polybarScripts = inputs.polybar-scripts;
          signal.desktop.editor.helix.src = inputs.helixSrc;
          signal.desktop.wayland.taskbar.waybar.src = inputs.waybarSrc;
          programs.fish.pluginSources = {
            done = inputs.fishDone;
          };
          signal.desktop.wayland.wallpaper.swww.src = inputs.swww;
        };
      };
    };
}
