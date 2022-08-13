{
  config,
  pkgs,
  utils,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.dev.editor.neovim;
in {
  options.dev.editor.neovim = with lib; {
    enable = mkEnableOption "Neovim editor";
  };
  imports = [];
  config = lib.mkIf (config.dev.enable && cfg.enable) {
    systemd.user.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    programs.neovim = {
      enable = false;
      package = if (config.home.impure or false) then (utils.wrapSystemApp { app = "nvim"; }) else pkgs.neovim;
    };
    home.packages =
      (std.optional (!config.programs.neovim.enable) config.programs.neovim.package)
      ++ (with pkgs; [
        tree-sitter
        nvimpager
      ])
      ++ (with pkgs.vimPlugins; [
        packer-nvim
        # editorconfig-nvim
        # vim-better-whitespace
        # popup-nvim
        # async-vim
        # vim-visual-multi
        # vim-repeat
        # vim-sensible
        # vim-surround
        # lightspeed-nvim
        # neogit
        # diffview-nvim
        # impatient-nvim
        # octo-nvim
        # nvim-dap
        # nvim-dap-ui
        # nvim-dap-virtual-text
        # telescope-dap-nvim
        # vista-vim
        # crates-nvim
        # rust-tools-nvim
        # SchemaStore-nvim
        # nvim-lspconfig
        # # mesonic
        # trouble-nvim
        # nvim-web-devicons
        # nvim-lint
        # statix
        # nvim-treesitter
        # playground
        # vim-vsnip
        # vim-vsnip-integ
        # nvim-autopairs
        # vim-easy-align
        # project-nvim
        # telescope-project-nvim
        # glow-nvim
        # nvim-cmp
        # lspkind-nvim
        # gruvbox-material
        # everforest
        # edge
        # sonokai
        # vim-illuminate
        # nvim-colorizer-lua
        # indent-blankline-nvim
        # todo-comments-nvim
        # skim-vim
        # hologram-nvim
        # ctrlp-vim
        # # aerojump.nvim
        # FTerm-nvim
        # undotree
        # nvim-tree-lua
        # vim-fugitive
        # vim-commentary
        # # vim-kitty
        # lualine-nvim
        # lsp-status-nvim
        # nvim-code-action-menu
        # which-key-nvim
        # nvim-notify
        # marks-nvim
        # minimap-vim
        # # focus.nvim
        # telescope-nvim
        # committia-vim
        # # vgit.nvim
        # # alpha-nvim
        # gitsigns-nvim
        # nvim-treesitter-context
        # # firenvim
        # # iptables-vim
        # # qt-support.vim
        # # vim-gitignore
        # gleam-vim
        # tabular
        # vim-polyglot
        # # isort.nvim
        # # nest.nvim
      ])
      ++ (with pkgs.lua53Packages; [
        plenary-nvim
        luasocket
        luaposix
      ]);
    # programs.nixvim = {
    #   enable = false;
    #   colorschemes.gruvbox = {
    #     enable = true;
    #     bold = true;
    #     italics = true;
    #     undercurl = true;
    #     underline = true;
    #     trueColor = true;
    #     contrastDark = "hard";
    #     contrastLight = "hard";
    #     transparentBg = true;
    #     improvedStrings = true;
    #     improvedWarnings = true;
    #   };
    #   options = {
    #     number = true;
    #   };
    #   globals.mapleader = ";";
    #   maps = {
    #     normal = { };
    #   };
    # };
  };
}
