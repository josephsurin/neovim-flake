{ pkgs, ... }:

/* lua */ ''
lspconfig.pyright.setup{
  capabilities = capabilities;
  on_attach = default_on_attach;
  cmd = {"${pkgs.pyright}/bin/pyright-langserver", "--stdio"},
  handlers = handlers,
}
''
