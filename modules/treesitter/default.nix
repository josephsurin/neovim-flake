{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [
      treeSitterPlug
      nvim-treesitter-playground
      nvim-treesitter-textobjects
    ];

    vim.luaConfigRC = /* lua */ ''
      -- ---------------------------------------
      -- Treesitter config
      -- ---------------------------------------
      require'nvim-treesitter.configs'.setup {
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
          disable = {"python"},
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = "<nop>",
            node_decremental = "<bs>",
          }
        },
        playground = {
          enable = true,
          disable = {},
          updatetime = 25,
          persist_queries = false,
          keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
          },
        },
        textobjects = {
          enable = true,
          swap = { enable = true, },
          select = { enable = true, },
          move = { enable = true, },
          lsp_interop = { enable = true, },
        },
        ensure_installed = {},
      }
    '';
  };
}
