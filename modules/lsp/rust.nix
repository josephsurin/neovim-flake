{ pkgs, ... }:

/* lua */ ''
local rustopts = {
  tools = {
    autoSetHints = true,
    hover_with_actions = false,
    inlay_hints = {
      only_current_line = false,
    }
  },
  server = {
    capabilities = capabilities,
    on_attach = function(client,bufnr)
      default_on_attach(client, bufnr)
      vim.keymap.set("n", "<C-space>", require("rust-tools").hover_actions.hover_actions, { buffer = bufnr })
      vim.keymap.set("n", "<Leader>ch", require("rust-tools").hover_range.hover_range, { buffer = bufnr })
    end,
    cmd = {"${pkgs.rust-analyzer}/bin/rust-analyzer"},
    settings = {
      ["rust-analyzer"] = {
        experimental = {
          -- procAttrMacros = true,
        },
        lru = {capacity = 32}, -- decrease memory usage
      },
    }
  },
  handlers = handlers,
}

require('crates').setup {
  null_ls = {
    enabled = true,
    name = "crates.nvim"
  }
}

require('rust-tools').setup(rustopts)
''
