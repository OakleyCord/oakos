{ config, pkgs, ... }:

{
  home.username = "oakley";
  home.homeDirectory = "/home/oakley";

  home.packages = with pkgs; [
    killall
  ];

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    ".config/hypr/scripts/autostart.sh".source = config/hypr/scripts/autostart.sh;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };



  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;



    extraConfig = ''
      ${builtins.readFile ./config/hypr/conf/colors.conf}
      ${builtins.readFile ./config/hypr/conf/binds.conf}
      ${builtins.readFile ./config/hypr/conf/exec.conf}
      ${builtins.readFile ./config/hypr/conf/monitors.conf}
      ${builtins.readFile ./config/hypr/hyprland.conf}
    '';
    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "oakley";
    userEmail = "oakleycord@proton.me";
  };

  gtk = {
    enable = true;
    theme.name = "rose-pine";
    cursorTheme.name = "Catppuccin-Macchiato-Dark";
    iconTheme.name = "Papirus-Dark";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
  };

  programs.starship = {
    enable = true;
  };

  programs.neovim = 
  let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";

  in
  {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [

      luajitPackages.lua-lsp
      # rust-analyzer
      # cargo
      rnix-lsp
    ];

    extraLuaConfig = ''

      ${builtins.readFile ./config/nvim/options.lua}
      ${builtins.readFile ./config/nvim/remap.lua}
    '';
    plugins = with pkgs.vimPlugins; [


      # icons
      nvim-web-devicons

      # time tracker
      vim-wakatime

      # syntax highlighting
      {
        plugin =  (nvim-treesitter.withPlugins (p: [
          p.tree-sitter-nix
          p.tree-sitter-vim
          p.tree-sitter-bash
          p.tree-sitter-lua
          p.tree-sitter-rust
          p.tree-sitter-json
        ]));
        config = toLuaFile ./config/nvim/plugins/treesitter.lua;
      }


      # code completion
      {
        plugin = nvim-cmp;
        config = toLuaFile ./config/nvim/plugins/cmp.lua;
      }

      cmp_luasnip
      cmp-nvim-lsp

      luasnip
      friendly-snippets

      # better nix support
      vim-nix

      # language server
      {
        plugin = nvim-lspconfig;
        config = toLuaFile ./config/nvim/plugins/lspconfig.lua;
      }

      # help and kinda like an lsp for neovim configs
      neodev-nvim

      {
        plugin = gitsigns-nvim;
        config = toLua "require(\"gitsigns\").setup()";
      }

      # search file thing
      {
        plugin = telescope-nvim;
        config = toLuaFile ./config/nvim/plugins/telescope.lua;
      }
      # make it fast
      telescope-fzf-native-nvim

      # replace nvim status bar
      {
        plugin = lualine-nvim;
        config = toLuaFile ./config/nvim/plugins/lualine.lua;
      }


      {
        plugin = vim-fugitive;
        config = toLuaFile ./config/nvim/plugins/fugitive.lua;
      }

      lualine-nvim

      # comments
      {
        plugin = comment-nvim;
        config = toLua "require(\"Comment\").setup()"; 
      }

      # file browser
      {
        plugin = nvim-tree-lua;
        config = toLuaFile ./config/nvim/plugins/nvim-tree.lua;
      }

      # theme
      {
        plugin = rose-pine;
        config = "colorscheme rose-pine";
      }

    ];
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.stateVersion = "22.11"; # Please read the comment before changing.
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
