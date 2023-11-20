{ inputs, config, pkgs, ... }:

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.agenix.homeManagerModules.age
    ./waybar/waybar.nix
  ];



  # fix agenix user service not restarting on switching configs
  # https://github.com/ryantm/agenix/issues/50#issuecomment-1729135009
  # MAY CAUSE WEIRD SIDE EFFECTS
  systemd.user.startServices = "sd-switch";

  # wakatime comfig
  age.secrets.wakatime-cfg = {
    file = ./secrets/wakatime.cfg.age;
    path = ".wakatime.cfg";
  };


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

    # image viewer
    imv

    # notify-send
    libnotify

    # notifications
    swaynotificationcenter


    # discord
    armcord

    firefox
    obs-studio
    jetbrains.idea-ultimate
    sublime-music
    kitty
    dolphin-emu
    # brokey :(
    # jellyfin-mpv-shim
    mpv
    prismlauncher
    lunar-client
    vscode
    gnome.gnome-software
    monero-gui
    thunderbird


    wl-screenrec
  ];


  # bluetooth :]
  services.blueman-applet.enable = true;

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # TODO: maybe just do the folder?
    ".config/hypr/scripts/autostart.sh".source = ./hypr/scripts/autostart.sh;
    ".config/hypr/scripts/replay_start.sh".source = ./hypr/scripts/replay_start.sh;
    ".config/hypr/scripts/replay_setup.sh".source = ./hypr/scripts/replay_setup.sh;

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

  systemd.user.services = {
    # rich presence
    arrpc = {
      Unit.Description = "Discord rich presence";
      Install.WantedBy = [ "graphical-session.target" ];
      Unit.Wants = [ "graphical-session.target" ];
      Unit.After = [ "graphical-session.target" ];
      Service = {
        ExecStart = "${pkgs.arrpc}/bin/arrpc";
      };
    };

    # polkit 
    polkit-gnome-agent = {
      Unit.Description = "polkit-gnome-authentication-agent-1";
      Install.WantedBy = [ "graphical-session.target" ];
      Unit.Wants = [ "graphical-session.target" ];
      Unit.After = [ "graphical-session.target" ];
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;


    plugins = [
      inputs.hyprfocus.packages.${pkgs.system}.default
      #brokey
#      inputs.hyprland-plugins.packages.${pkgs.system}.csgo-vulkan-fix
      # does not work on latest git version of hyprland while hyprfocus only works on latest git version
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
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

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
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
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
    "text/html" = [ "firefox.desktop "];
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
      nixd
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


      # cool notifcations on nvim
      {
        plugin = nvim-notify;
        config = toLuaFile ./nvim/plugins/notify.lua;
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

      # discord status
      {
        plugin = presence-nvim; 
        config = toLuaFile ./nvim/plugins/presence.lua;
      }

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
    # fix gamescope on steam
    # TODO: move to gaming.nix module
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    #SDL_VIDEODRIVER = "x11";
    CLUTTER_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "22.11"; # Please read the comment before changing.
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
