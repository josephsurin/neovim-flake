{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.coding;
in {
  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [
      lua-snip
      friendly-snippets
      nvim-cmp lspkind
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-luasnip
      mini-pairs
      vim-surround
      mini-comment
      nvim-ts-commentstring
      mini-ai
      prettier
      dropbar
      conform
    ];

    vim.luaConfigRC = /* lua */ ''
      -- ---------------------------------------
      -- Coding Config
      -- ---------------------------------------
      -- Luasnip config
      require'luasnip'.setup({
          history = true,
          delete_check_events = "TextChanged",
      })
      require("luasnip.loaders.from_vscode").lazy_load()
      local has_words_before = function()
          unpack = unpack or table.unpack
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      --Luasnip keys
      local cmp = require'cmp'
      local ls = require'luasnip'
      vim.keymap.set({"i", "s"}, "<C-j>", function()
          if cmp.visible() then
          cmp.select_next_item()
          end
      end, {silent = true})
      vim.keymap.set({"i", "s"}, "<C-k>", function()
          if cmp.visible() then
          cmp.select_prev_item()
          end
      end, {silent = true})

      vim.keymap.set({"i", "s"}, "<C-h>", function()
          if ls.jumpable(-1) then
          ls.jump(-1)
          end
      end, {silent = true})
      vim.keymap.set({"i", "s"}, "<C-l>", function()
          if ls.expand_or_jumpable() then
          ls.expand_or_jump()
          elseif has_words_before() then
          cmp.complete()
          end
      end, {silent = true})

      vim.keymap.set({"i", "s"}, "<C-E>", function()
          if ls.choice_active() then
          ls.change_choice(1)
          end
      end, {silent = true})
      local cmp = require'cmp'
      local lspkind = require'lspkind'
      local function border(hl_name)
          return {
          { "╭", hl_name },
          { "─", hl_name },
          { "╮", hl_name },
          { "│", hl_name },
          { "╯", hl_name },
          { "─", hl_name },
          { "╰", hl_name },
          { "│", hl_name },
          }
      end
      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = {
              side_padding = 1,
              winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel",
              scrollbar = false,
              border = border "CmpBorder",
          },
          documentation = {
              border = border "CmpDocBorder",
              winhighlight = "Normal:CmpDoc",
          },
        },
        mapping = cmp.mapping.preset.insert({
          ["<M-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<M-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-l>"] = cmp.mapping.confirm({ select = true }),
          ["<S-CR"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer", keyword_length = 5 },
          { name = "path" },
        }),
        formatting = {
          format = lspkind.cmp_format()
        },
        experimental = {
          ghost_text = { hl_group = "LspCodeLens" },
        },
      })
      require("mini.pairs").setup()
      require("mini.comment").setup({
        hooks = {
          pre = function()
            require("ts_context_commentstring.internal").update_commentstring({})
          end,
        },
      })
      -- mini.ai config
      require("mini.ai").setup({
        n_lines = 500,
        custom_textobjects = {
          o = require("mini.ai").gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = require("mini.ai").gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = require("mini.ai").gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      })

    -- dropbar
    local dropbar_api = require('dropbar.api')
    vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
    vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
    vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
    require('dropbar').setup({
      menu = {
        keymaps = {
          ['h'] = '<C-w>q',
          ['l'] = function()
            local dropbar = require('dropbar')
            local utils = require('dropbar.utils')
            local menu = utils.menu.get_current()
            if not menu then
              return
            end
            local cursor = vim.api.nvim_win_get_cursor(menu.win)
            local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
            if component then
              menu:click_on(component, nil, 1, 'l')
            end
          end,
        }
      }
    })

    -- conform
    require("conform").setup({
      formatters_by_ft = {
        python = { "ruff_format" }
      },
    })
    vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
            local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                range = {
                    start = { args.line1, 0 },
                    ["end"] = { args.line2, end_line:len() },
                }
            end
        require("conform").format({ async = true, lsp_format = "fallback", range = range })
    end, { range = true })
    '';
  };
}
