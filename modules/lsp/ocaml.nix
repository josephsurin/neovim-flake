{ pkgs, ... }:

/* lua */ ''
vim.lsp.config('ocamllsp', {
  capabilities = capabilities;
  on_attach = function(client, bufnr)
    attach_keymaps(client, bufnr)
  end,
  cmd = { "${pkgs.ocamlPackages.ocaml-lsp}/bin/ocamllsp" },
  handlers = handlers,
})
vim.lsp.enable('ocamllsp')
''
