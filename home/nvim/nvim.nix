{ inputs, config, pkgs, ... }:
{
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

      jdt-language-server
      nixd
    ];

    extraLuaConfig = ''
    ${builtins.readFile ./options.lua}
    ${builtins.readFile ./remap.lua}
    '';

    
    plugins = with pkgs.vimPlugins; [


      # icons
      nvim-web-devicons

      # time tracker
      vim-wakatime

      # syntax highlighting
      {
        plugin = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;

        #   (nvim-treesitter.withPlugins (p: [
        #   p.tree-sitter-nix
        #   p.tree-sitter-vim
        #   p.tree-sitter-bash
        #   p.tree-sitter-lua
        #   p.tree-sitter-rust
        #   p.tree-sitter-rust
        #   p.tree-sitter-json
        # ]));
        config = toLuaFile ./plugins/treesitter.lua;
      }


      # cool notifcations on nvim
      {
        plugin = nvim-notify;
        config = toLuaFile ./plugins/notify.lua;
      }



      # extra features when working with rust
      {
        plugin = rust-tools-nvim;
        config = toLua "require(\"rust-tools\").setup()";
      }


      # code completion
      {
        plugin = nvim-cmp;
        config = toLuaFile ./plugins/cmp.lua;
      }

      cmp_luasnip
      cmp-nvim-lsp

      luasnip
      friendly-snippets

      # discord status
      {
        plugin = presence-nvim; 
        config = toLuaFile ./plugins/presence.lua;
      }

      # auto pairing
      {
        plugin = nvim-autopairs;
        config = toLuaFile ./plugins/autopair.lua;
      }

      # better nix support
      vim-nix

      # language server
      {
        plugin = nvim-lspconfig;
        config = toLuaFile ./plugins/lspconfig.lua;
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
        config = toLuaFile ./plugins/telescope.lua;
      }
      # make it fast
      telescope-fzf-native-nvim

      # replace nvim status bar
      {
        plugin = lualine-nvim;
        config = toLuaFile ./plugins/lualine.lua;
      }


      {
        plugin = vim-fugitive;
        config = toLuaFile ./plugins/fugitive.lua;
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
        config = toLuaFile ./plugins/nvim-tree.lua;
      }

      # theme
      {
        plugin = rose-pine;
        config = "colorscheme rose-pine";
      }

    ];
  };
}
