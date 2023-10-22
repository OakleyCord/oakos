{ config, pkgs, ... }:

{
  home.username = "oakley";
  home.homeDirectory = "/home/oakley";

  home.packages = with pkgs; [
    killall


    # screnshotting
    sway-contrib.grimshot
    grim
    slurp
    swappy
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



  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;



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

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      ${builtins.readFile ./waybar/macchiato.css}
      ${builtins.readFile ./waybar/style.css} 
    '';
    settings = [{
      layer = "top";
      margin-top = 5;
      margin-left = 5;
      margin-right = 5;
      modules-left = ["hyprland/workspaces" "backlight" "pulseaudio" "network"];
      modules-center = ["clock"];
      modules-right =  ["temperature" "cpu" "memory" "battery" "tray"];
      "wlr/workspaces" = {
        format = "{icon}";
        on-click = "activate";
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
      };
      backlight = {
        device = "amd_backlight";
        format = "{percent}% {icon} ";
        format-icons = ["󰃞" "󰃝" "󰃠"];
        on-scroll-up = "brightnessctl s +5%";
        on-scroll-down = "brightnessctl s 5%-";
      };
      pulseaudio = { 
        format = "{volume}% {icon} {format_source}";
        format-bluetooth = "{volume}% {icon}  {format_source}";
        format-bluetooth-muted = " {icon}  {format_source}";
        format-muted = "婢 {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["奄" "奔" "墳"];
        };
        on-click = "killall pavucontrol || pavucontrol"; 
      };
      network = {
        format = "{ifname}";
        format-wifi = "{ipaddr} {icon} ";
        format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
        format-ethernet = "{ipaddr}/{cidr} 󰈀 ";
        format-disconnected = "󰤮 ";
        tooltip-format = "{ifname} via {gwaddr} 󰈀 ";
        tooltip-format-wifi = "{essid} ({signalStrength}%) {icon} ";
        tooltip-format-ethernet = "{ifname}  ";
        tooltip-format-disconnected = "Disconnected";
        max-length = 50;
        on-click = "nm-connection-editor";
      };
      clock = {
        format = "{:%a, %d. %b  %H:%M}";
      };
      temperature = {
        critical-threshold = 80;
        format-critical = "{temperatureC}°C ";
        format = "{temperatureC}°C ";
      };
      cpu = {
        interval = 10;
        format = "{usage}% ({avg_frequency}GHz)  ";
        states = {
          warning = 25;
          critical = 75;
        };
      };
      memory = {
        interval = 30;
        format = "{percentage}% ({used:0.1f}G/{total:0.1f}G)  ";
      };
      battery = {
        bat = "BAT0";
        states = {
          warning = 35;
          critical = 20;
        };
        format = "{capacity}% (-{power}W) {icon} ";
        format-icons = ["" "" "" "" ""];
        format-charging = "{capacity}% (+{power}W) {icon}  ";
      };
      tray = {
        icon-size = 21;
        spacing = 10;
      };
    }];
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


      # code completion
      {
        plugin = nvim-cmp;
        config = toLuaFile ./nvim/plugins/cmp.lua;
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
