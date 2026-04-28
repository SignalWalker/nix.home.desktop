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

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      nixpkgs,
      ...
    }:
    let
      std = nixpkgs.lib;
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      nixpkgsFor = std.genAttrs systems (
        system:
        import nixpkgs {
          localSystem = builtins.currentSystem or system;
          crossSystem = system;
          overlays = [ ];
        }
      );
    in
    {
      formatter = std.mapAttrs (system: pkgs: pkgs.nixfmt) nixpkgsFor;
      homeModules.default =
        {
          pkgs,
          ...
        }:
        {
          imports = [
            inputs.caelestia-shell.homeManagerModules.default
            # inputs.watch-battery.homeManagerModules.default
            inputs.ashvim.homeManagerModules.default
            inputs.lan-mouse.homeManagerModules.default
            inputs.nixcord.homeModules.default
            inputs.walker.homeManagerModules.default
            # inputs.stylix.homeModules.stylix
            ./home-manager.nix
          ];
          config = {

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
        };
      devShells = std.mapAttrs (
        system: pkgs:
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
        }
      ) nixpkgsFor;
    };
}
