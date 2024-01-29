{ pkgs, ... }:

/* lua */ ''
lspconfig.gopls.setup{
  capabilities = capabilities;
  on_attach = default_on_attach;
  cmd = {"${pkgs.gopls}/bin/gopls", "serve"},
}
''
