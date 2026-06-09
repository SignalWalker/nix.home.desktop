{
  description = "Home manager configuration - graphical desktop";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # theme
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # services
    # watch-battery = {
    #   url = "git+https://git.ashwalker.net/ash/watch-battery";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # wayland
    yofi = {
      type = "github";
      owner = "l4l";
      repo = "yofi";
      ref = "0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # quickshell = {
    #   url = "github:quickshell-mirror/quickshell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    ## wallpaper
    awww = {
      url = "git+https://codeberg.org/LGFae/awww";
      inputs.nixpkgs.follows = "nixpkgs";
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
    rose-pine-qt5ct = {
      url = "github:piperbly/rose-pine-qt5ct";
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
    # lorri = {
    #   url = "github:nix-community/lorri";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    ## editor
    ashvim = {
      url = "github:signalwalker/cfg.neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ashmacs = {
      url = "github:signalwalker/cfg.emacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # file explorer
    yazi = {
      url = "github:sxyazi/yazi";
    };

    lan-mouse = {
      url = "github:feschber/lan-mouse";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:KaylorBen/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # shell
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # app launcher
    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # psysonic = {
    #   url = "github:Psychotoxical/psysonic";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    pyproject = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pyproject-nix.follows = "pyproject";
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        ...
      }:
      {

        flake = {
          homeModules.default = (import ./home-module.nix) inputs;
        };
        systems = [ "x86_64-linux" ];
        perSystem =
          { pkgs, ... }:
          {
            formatter = pkgs.nixfmt;
            packages = {
              # why is it so hard to package python applications...
              wallmaster =
                let
                  lib = inputs.nixpkgs.lib;
                  pyproject = inputs.pyproject;
                  uv = inputs.uv2nix;
                  workspace = uv.lib.workspace.loadWorkspace { workspaceRoot = ./pkg/wallmaster; };
                  overlay = workspace.mkPyprojectOverlay {
                    sourcePreference = "wheel";
                  };
                  python = pkgs.python3;
                  pythonSet =
                    (pkgs.callPackage pyproject.build.packages {
                      inherit python;
                    }).overrideScope
                      (
                        lib.composeManyExtensions [
                          inputs.pyproject-build-systems.overlays.wheel
                          overlay
                        ]
                      );
                in
                (pkgs.callPackages pyproject.build.util { }).mkApplication {
                  venv = pythonSet.mkVirtualEnv "wallmaster-env" workspace.deps.default;
                  package = pythonSet.wallmaster;
                };
            };
            devShells =
              let
                qt = pkgs.qt6;
                qtEnv = qt.env "qt-custom-${qt.qtbase.version}" [
                  qt.qtdeclarative
                  qt.qtsvg
                  qt.qtimageformats
                  qt.qtmultimedia
                  qt.qt5compat
                  pkgs.libglvnd
                ];
              in
              {
                default = pkgs.mkShell {
                  buildInputs = [
                    qtEnv
                    pkgs.quickshell
                  ];
                  shellHook = ''
                    # Required for qmlls to find the correct type declarations
                    export QMLLS_BUILD_DIRS=${qtEnv}/lib/qt-6/qml/:${pkgs.quickshell}/lib/qt-6/qml/
                    export QML_IMPORT_PATH=$PWD/src/wayland/taskbar/quickshell
                  '';
                };
              };
          };
      }
    );
}
