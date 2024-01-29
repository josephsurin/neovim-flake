{ pkgs, ... }:

/* lua */ ''
lspconfig.nil_ls.setup{
  capabilities = capabilities;
  on_attach = function(client, bufnr)
    attach_keymaps(client, bufnr)
  end,
  cmd = {"${pkgs.nil}/bin/nil"},
  handlers = handlers,
}
''
