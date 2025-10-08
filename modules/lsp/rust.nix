{ pkgs, ... }:

/* lua */ ''
vim.g.rustaceanvim = {
  server = {
    on_attach = default_on_attach,
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
}

require('crates').setup()
''