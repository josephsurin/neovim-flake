{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.lsp;
  lspConfigs = concatStringsSep "\n\n" (attrValues
    (attrsets.mapAttrs
      (n: v: import ./${n}.nix { inherit config pkgs; })
      (attrsets.filterAttrs (n: v: v == true) cfg.languages))
  );
in {
  options.vim.lsp = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable LSP plugins";
    };

    languages = {
      lua = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Lua LSP Server";
      };
      nix = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Nix LSP Server";
      };
      rust = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Rust LSP Server";
      };
      go = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Golang LSP Server";
      };
      ocaml = mkOption {
        type = types.bool;
        default = false;
        description = "Enable OCaml LSP server";
      };
      c = mkOption {
        type = types.bool;
        default = false;
        description = "Enable C/C++ LSP Server";
      };
      python = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Python LSP Server";
      };
      typescript = mkOption {
        type = types.bool;
        default = false;
        description = "Enable TypeScript LSP Server";
      };
      vimscript = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Vimscript LSP Server";
      };
      html = mkOption {
        type = types.bool;
        default = false;
        description = "Enable HTML LSP Server";
      };
      tailwindcss = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Tailwind CSS LSP Server";
      };
      eslint = mkOption {
        type = types.bool;
        default = false;
        description = "Enable eslint LSP Server";
      };
      sourcekit = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Sourcekit LSP Server";
      };
      sourcekit-cmd = mkOption {
        type = types.path;
        default = "/usr/bin/sourcekit-lsp";
        description = "Path to sourcekit-lsp binary";
      };
      ruby = mkOption { # TODO: implement this
        type = types.bool;
        default = false;
        description = "Enable Ruby LSP Server";
      };
    };
  };
  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [
      nvim-lspconfig null-ls inc-rename
      neoconf
      crates-nvim rust-tools
    ];

    vim.luaConfigRC = /* lua */ ''
      -- ---------------------------------------
      -- LSP Config
      -- ---------------------------------------

      -- Global LSP options
      require("inc_rename").setup()

      vim.diagnostic.config({
        virtual_text = true,
        signs = {
            active = signs,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
      })

      -- Rounded borders in popups, these are used in each lspconfig setup call
      -- because global overrides weren't working...
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

      local handlers =  {
        ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border "FloatBorder" }),
        ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border "FloatBorder" }),
      }

      -- Utility function to goto by severity
      function diagnostic_goto(next, severity)
        local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
        severity = severity or nil
        return function()
          go({ severity = severity })
        end
      end

      -- Utility function to trigger formatting based on format engine
      function format()
        local buf = vim.api.nvim_get_current_buf()
        if vim.b.autoformat == false then
          return
        end
        local ft = vim.bo[buf].filetype
        local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0

        vim.lsp.buf.format(vim.tbl_deep_extend("force", {
          bufnr = buf,
          filter = function(client)
            if have_nls then
              return client.name == "null-ls"
            end
            return client.name ~= "null-ls"
          end,
        },{}))
      end

      -- Utility function to set keymaps by LSP-active buffer
      local attach_keymaps = function(client, bufnr)
        map("n","<leader>cd",function() vim.diagnostic.open_float() end,{desc="Line Diagnostics",remap=false,silent=true,buffer=bufnr})
        map("n","<leader>cl","<cmd>LspInfo<cr>",{desc="Lsp Info",remap=false,silent=true,buffer=bufnr})
        map("n","gd","<cmd>Telescope lsp_definitions<cr>",{desc="Goto Definition",remap=false,silent=true,buffer=bufnr})
        map("n","gr","<cmd>Telescope lsp_references<cr>",{desc="References",remap=false,silent=true,buffer=bufnr})
        map("n","gD",function() vim.lsp.buf.declaration() end,{desc="Goto Declaration",remap=false,silent=true,buffer=bufnr})
        map("n","gI","<cmd>Telescope lsp_implementations<cr>",{desc="Goto Implementation",remap=false,silent=true,buffer=bufnr})
        map("n","gy","<cmd>Telescope lsp_type_definitions<cr>",{desc="Goto Type Definition",remap=false,silent=true,buffer=bufnr})
        map("n","K",function() vim.lsp.buf.hover() end,{desc="Hover",remap=false,silent=true,buffer=bufnr})
        map("n","gK",function() vim.lsp.buf.signature_help() end,{desc="Signature Help",remap=false,silent=true,buffer=bufnr})
        map("n","<leader>ld",diagnostic_goto(true),{desc="Next Diagnostic",remap=false,silent=true,buffer=bufnr})
        map("n","<leader>hd",diagnostic_goto(false),{desc="Prev Diagnostic",remap=false,silent=true,buffer=bufnr})
        map("n","<leader>le",diagnostic_goto(true, "ERROR"),{desc="Next Error",remap=false,silent=true,buffer=bufnr})
        map("n","<leader>he",diagnostic_goto(false, "ERROR"),{desc="Prev Error",remap=false,silent=true,buffer=bufnr})
        map("n","<leader>lw",diagnostic_goto(true, "WARN"),{desc="Next Warning",remap=false,silent=true,buffer=bufnr})
        map("n","<leader>hw",diagnostic_goto(false, "WARN"),{desc="Prev Warning",remap=false,silent=true,buffer=bufnr})
        map("n","<leader>cf",function() vim.lsp.buf.format() end,{desc="Format Document",remap=false,silent=true,buffer=bufnr})
        map("v","<leader>cf",function() vim.lsp.buf.format() end,{desc="Format Range",remap=false,silent=true,buffer=bufnr})
        map("n","<leader>ca",function() vim.lsp.buf.code_action() end,{desc="Code Action",remap=false,silent=true,buffer=bufnr})
        map("n","<leader>cA",function() vim.lsp.buf.code_action({ apply = true }) end,{desc="Apply code action",remap=false,silent=true,buffer=bufnr})
        map(
          "n",
          "<leader>cr",
          function()
            local inc_rename = require("inc_rename")
            return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
          end,
          {desc="Rename",expr = true}
        )
      end

      -- Auto format autocommand to be used by null-ls
      local nls_augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      format_callback = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = nls_augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = nls_augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                bufnr = bufnr,
                filter = function(client)
                  return client.name == "null-ls"
                end,
              })
            end,
          })
        end
      end

      default_on_attach = function(client, bufnr)
        attach_keymaps(client, bufnr)
        format_callback(client, bufnr)
      end

      require("neoconf").setup()

      -- Enable lspconfig
      local lspconfig = require('lspconfig')
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      ${lspConfigs}
    '';
  };
}
