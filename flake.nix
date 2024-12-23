{
  description = "Neovim flake, modified from github:cwfryer/neovim-flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    #-------------------------------------
    # Coding Plugins
    #-------------------------------------
    lua-snip = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };
    friendly-snippets = {
      url = "github:rafamadriz/friendly-snippets";
      flake = false;
    };
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    cmp-luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };
    lspkind = {
      url = "github:onsails/lspkind.nvim";
      flake = false;
    };
    mini-pairs = {
      url = "github:echasnovski/mini.pairs";
      flake = false;
    };
    vim-surround = {
      url = "github:tpope/vim-surround";
      flake = false;
    };
    nvim-ts-commentstring = {
      url = "github:JoosepAlviste/nvim-ts-context-commentstring";
      flake = false;
    };
    mini-comment = {
      url = "github:echasnovski/mini.comment";
      flake = false;
    };
    mini-ai = {
      url = "github:echasnovski/mini.ai";
      flake = false;
    };
    prettier = {
      url = "github:prettier/vim-prettier";
      flake = false;
    };
    dropbar = {
      url = "github:Bekaboo/dropbar.nvim";
      flake = false;
    };

    #-------------------------------------
    # Colorscheme Plugins
    #-------------------------------------
    gruvbox = {
      url = "github:ellisonleao/gruvbox.nvim";
      flake = false;
    };
    gruvbox-material = {
      url = "github:sainnhe/gruvbox-material";
      flake = false;
    };
    tokyonight = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };
    nvim-transparent = {
      url = "github:xiyaowong/nvim-transparent";
      flake = false;
    };

    #-------------------------------------
    # Editor Plugins
    #-------------------------------------
    neo-tree = {
      url = "github:nvim-neo-tree/neo-tree.nvim";
      flake = false;
    };
    nvim-spectre = {
      url = "github:nvim-pack/nvim-spectre";
      flake = false;
    };
    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    leap = {
      url = "github:ggandor/leap.nvim";
      flake = false;
    };
    which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };
    gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    vim-illuminate = {
      url = "github:RRethy/vim-illuminate";
      flake = false;
    };
    mini-bufremove = {
      url = "github:echasnovski/mini.bufremove";
      flake = false;
    };
    trouble = {
      url = "github:folke/trouble.nvim";
      flake = false;
    };
    todo-comments = {
      url = "github:folke/todo-comments.nvim";
      flake = false;
    };
    toggleterm = {
      url = "github:akinsho/toggleterm.nvim";
      flake = false;
    };
    vim-visual-multi = {
      url = "github:mg979/vim-visual-multi";
      flake = false;
    };

    #-------------------------------------
    # LSP Plugins
    #-------------------------------------
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    lsp-status = {
      url = "github:nvim-lua/lsp-status.nvim";
      flake = false;
    };
    neoconf = {
      url = "github:folke/neoconf.nvim";
      flake = false;
    };
    neodev = {
      url = "github:folke/neodev.nvim";
      flake = false;
    };
    null-ls = {
      url = "github:jose-elias-alvarez/null-ls.nvim";
      flake = false;
    };
    crates-nvim = {
      url = "github:Saecki/crates.nvim";
      flake = false;
    };
    rust-tools = {
      url = "github:simrat39/rust-tools.nvim";
      flake = false;
    };
    inc-rename = {
      url = "github:smjonas/inc-rename.nvim";
      flake = false;
    };
    xcodebuild = {
      url = "github:wojciech-kulik/xcodebuild.nvim";
      flake = false;
    };

    #-------------------------------------
    # Treesitter Plugins
    #-------------------------------------
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    nvim-treesitter-playground = {
      url = "github:nvim-treesitter/playground";
      flake = false;
    };
    nvim-treesitter-textobjects = {
      url = "github:nvim-treesitter/nvim-treesitter-textobjects";
      flake = false;
    };

    #-------------------------------------
    # UI Plugins
    #-------------------------------------
    nvim-notify = {
      url = "github:rcarriga/nvim-notify";
      flake = false;
    };
    dressing = {
      url = "github:stevearc/dressing.nvim";
      flake = false;
    };
    bufferline = {
      url = "github:akinsho/bufferline.nvim";
      flake = false;
    };
    lualine = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };
    mini-indentscope = {
      url = "github:echasnovski/mini.indentscope";
      flake = false;
    };
    noice = {
      url = "github:folke/noice.nvim";
      flake = false;
    };
    nui = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };
    nvim-navic = {
      url = "github:SmiteshP/nvim-navic";
      flake = false;
    };
    nvim-web-devicons = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };
    mini-icons = {
      url = "github:echasnovski/mini.icons";
      flake = false;
    };
    hex-nvim = {
      url = "github:RaafatTurki/hex.nvim";
      flake = false;
    };
    zen-mode = {
      url = "github:folke/zen-mode.nvim";
      flake = false;
    };

    #-------------------------------------
    # Utility Plugins
    #-------------------------------------
    persistence = {
      url = "github:folke/persistence.nvim";
      flake = false;
    };
    plenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        plugins = let
          f = xs: pkgs.lib.attrsets.filterAttrs (k: v: !builtins.elem k xs);

          nonPluginInputNames = [
            "self"
            "nixpkgs"
            "flake-utils"
            "neovim-nightly-overlay"
          ];
        in
          builtins.attrNames (f nonPluginInputNames inputs);

        pluginOverlay = import ./lib/buildPlugin.nix { inherit pkgs inputs plugins; };
        neovimBuilder = import ./lib/neovimBuilder.nix { inherit pkgs inputs plugins; };

        neovimOverlay = f: p: {
          neovim-nightly = inputs.neovim-nightly-overlay.packages.${system}.neovim;
        };

        pkgs = import nixpkgs {
          inherit system;
          config = {allowUnfree = true;};
          overlays = [pluginOverlay neovimOverlay];
        };

        defaults = {
          vim = {
            colorscheme = "gruvbox-material";
            lsp = {
              enable = true;
              languages = {
                c = true;
                lua = true;
                nix = true;
                rust = true;
                go = true;
                python = true;
                typescript = true;
                eslint = true;
                sourcekit = true;
                html = true;
                tailwindcss = true;
              };
            };
          };
        };
      in rec {
        apps = rec {
          nvim = {
            type = "app";
            program = "${packages.default}/bin/nvim";
          };

          default = nvim;
        };

        overlays.default = f: p: {
          inherit neovimBuilder;
          inherit (pkgs) neovim-nightly neovimPlugins;
        };

        inherit neovimBuilder;

        nixosModules.hm = {
          imports = [
            ./lib/hm.nix
            {nixpkgs.overlays = [overlays.default];}
          ];
        };

        packages = {
          default = (neovimBuilder { config = defaults; }).neovim;
        };
      }
    );
}
