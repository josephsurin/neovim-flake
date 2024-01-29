{ pkgs, ... }:

/* lua */ ''
lspconfig.ocamllsp.setup{
  capabilities = capabilities;
  on_attach = function(client, bufnr)
    attach_keymaps(client, bufnr)
  end,
  cmd = { "${pkgs.ocamlPackages.ocaml-lsp}/bin/ocamllsp" },
  handlers = handlers,
}
''
