{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = {
    vim.startPlugins = with pkgs.neovimPlugins; [
        noice nvim-notify nui
        dressing
        nvim-web-devicons
        bufferline
        lualine
        lsp-status
        nvim-navic
        mini-indentscope
    ];

    vim.configRC = /* vim */ ''
      set fillchars+=vert:\ ,vertright:─
    '';

    vim.luaConfigRC = /* lua */ ''
      -- ---------------------------------------
      -- UI Config
      -- ---------------------------------------

      require('noice').setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
            ["vim.lsp.util.stylize_markdown"] = false,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          lsp_doc_border = true,
        },
      })
      map("n","<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, { desc = "Redirect Cmdline" })
      map("n","<leader>snl", function() require("noice").cmd("last") end, { desc = "Noice Last Message"})
      map("n","<leader>snh", function() require("noice").cmd("history") end, { desc = "Noice History"})
      map("n","<leader>sna", function() require("noice").cmd("all") end, { desc = "Noice All"})
      map("n","<leader>snd", function() require("noice").cmd("dismiss") end, { desc = "Dismiss All"})

      local search = vim.api.nvim_get_hl_by_name("Search", true)
      vim.api.nvim_set_hl(0, 'TransparentSearch', { fg = search.foreground })

      local help = vim.api.nvim_get_hl_by_name("IncSearch", true)
      vim.api.nvim_set_hl(0, 'TransparentHelp', { fg = help.foreground })

      local cmdGroup = 'DevIconLua'
      local noice_cmd_types = {
        CmdLine    = cmdGroup,
        Input      = cmdGroup,
        Lua        = cmdGroup,
        Filter     = cmdGroup,
        Rename     = cmdGroup,
        Substitute = "Define",
        Help       = "TransparentHelp",
        Search     = "TransparentSearch"
      }

      for type, hl in pairs(noice_cmd_types) do
        vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder" .. type, { link = hl })
        vim.api.nvim_set_hl(0, "NoiceCmdlineIcon" .. type,        { link = hl })
      end
      vim.api.nvim_set_hl(0, "NoiceConfirmBorder", { link = cmdGroup })

      vim.notify = require("notify").setup({
        background_colour = "#000000",
        timeout = 3000,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
      })
      map("n","<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        {desc = "Delete all notifications"}
      )

      require('dressing').setup()
      require('nvim-web-devicons').setup()

      vim.opt.termguicolors = true
      require("bufferline").setup({
        options = {
          close_command = function(n) require("mini.bufremove").delete(n, false) end,
          right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
          themable = true,
          diagnostics = "nvim_lsp",
          always_show_bufferline = false,
          show_buffer_close_icons = false,
          show_close_icon = false,
          separator_style = "thin",
          indicator = {
            icon = "▏",
            style = "icon",
          },
          diagnostics_indicator = function(_,_,diag)
            local icons = {
              Error = " ",
              Warn = " ",
              Hint = " ",
              Info = " ",
            }
            local ret = (diag.error and icons.Error .. diag.error .. " " or "")
              .. (diag.warning and icons.Warn .. diag.warning or "")
            return vim.trim(ret)
          end,
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              text_align = "center",
              highlight = "NeoTreeNormal",
            },
          },
        },
      })
      map("n","<leader>bp","<cmd>BufferLineTogglePin<CR>", { desc = "Toggle pin" })
      map("n","<leader>bP","<cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete non-pinned buffers" })

      require('lualine').setup({
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" }},
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 1 } },
            { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
            {
              function() return require('nvim-navic').get_location() end,
              cond = function() return require('nvim-navic').is_available() end,
            },
          },
          lualine_y = {
            {
              "diagnostics",
              symbols = {
                error = " ",
                warn = " ",
                hint = " ",
                info = " ",
              },
            },
            {
              "diff",
              symbols = {
                added = " ",
                modified = " ",
                removed = " ",
              },
            },
          },
          lualine_z = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
        },
        extensions = { "neo-tree" },
      })

      vim.g.navic_silence = true
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buffer = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client.server_capabilities.documentSymbolProvider then
            require("nvim-navic").attach(client, buffer)
          end
        end,
      })

      require("mini.indentscope").setup({
        symbol = "│",
        options = { try_as_border = true },
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {"help", "alpha", "dashboard", "neo-tree", "Trouble", "toggleterm"},
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    '';
  };
}
