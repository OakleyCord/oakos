{ inputs, config, pkgs, ... }:

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./waybar/waybar.nix
  ];


  home.username = "oakley";
  home.homeDirectory = "/home/oakley";

  home.packages = with pkgs; [
    killall


    # screnshotting
    sway-contrib.grimshot
    grim
    slurp
    swappy

    # file manager
    gnome.nautilus

    # audio control
    pavucontrol
    imv
  ];

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    ".config/hypr/scripts/autostart.sh".source = ./hypr/scripts/autostart.sh;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };


  # nix-color theme
  colorScheme = inputs.nix-colors.colorSchemes.rose-pine;


  programs.kitty = {
    enable = true;
    theme = "Rosé Pine";

    settings = {
      background_opacity = "0.85";
      confirm_os_window_close = "0";
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;


    plugins = [
      inputs.hyprfocus.packages.${pkgs.system}.default
      # does not work on latest git version of hyprland while hyprfocus only works on latest git version
     # inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];

    extraConfig = ''
      ${builtins.readFile ./hypr/conf/colors.conf}
      ${builtins.readFile ./hypr/conf/binds.conf}
      ${builtins.readFile ./hypr/conf/exec.conf}
      ${builtins.readFile ./hypr/conf/monitors.conf}
      ${builtins.readFile ./hypr/hyprland.conf}
    '';
    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;
  };

  services.swayosd.enable = true;

  programs.git = {
    enable = true;
    userName = "oakley";
    userEmail = "oakleycord@proton.me";
  };

  gtk = {
    enable = true;
    theme.name = "rose-pine";
    theme.package = pkgs.rose-pine-gtk-theme;
    cursorTheme.name = "Catppuccin-Macchiato-Dark";
    cursorTheme.package = pkgs.catppuccin-cursors;
    iconTheme.name = "Papirus-Dark";
    iconTheme.package = pkgs.papirus-icon-theme;
    font.name = "source-code-pro";
    font.package = pkgs.nerdfonts;
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "adwiada-qt";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
  };

  programs.starship = {
    enable = true;
  };

  xdg.mimeApps.defaultApplications = {
    "text/plain" = [ "neovim-wrapper.desktop" ];
    "inode/directory" = [ "dolphin.desktop" ];
    "image/*" = [ "imv.desktop" ];
    "video/png" = [ "mpv.desktop" ];
    "video/*" = [ "mpv.desktop" ];
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

      ${builtins.readFile ./nvim/options.lua}
      ${builtins.readFile ./nvim/remap.lua}
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
        config = toLuaFile ./nvim/plugins/treesitter.lua;
      }
      

      # extra features when working with rust
      {
        plugin = rust-tools-nvim;
        config = toLua "require(\"rust-tools\").setup()";
      }


      # code completion
      {
        plugin = nvim-cmp;
        config = toLuaFile ./nvim/plugins/cmp.lua;
      }

      cmp_luasnip
      cmp-nvim-lsp

      luasnip
      friendly-snippets


      # auto pairing
      {
        plugin = nvim-autopairs;
        config = toLuaFile ./nvim/plugins/autopair.lua;
      }

      # better nix support
      vim-nix

      # language server
      {
        plugin = nvim-lspconfig;
        config = toLuaFile ./nvim/plugins/lspconfig.lua;
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
        config = toLuaFile ./nvim/plugins/telescope.lua;
      }
      # make it fast
      telescope-fzf-native-nvim

      # replace nvim status bar
      {
        plugin = lualine-nvim;
        config = toLuaFile ./nvim/plugins/lualine.lua;
      }


      {
        plugin = vim-fugitive;
        config = toLuaFile ./nvim/plugins/fugitive.lua;
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
        config = toLuaFile ./nvim/plugins/nvim-tree.lua;
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
