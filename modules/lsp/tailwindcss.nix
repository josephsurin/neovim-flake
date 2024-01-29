{ pkgs, ... }:

/* lua */ ''
lspconfig.tailwindcss.setup{
  capabilities = capabilities;
  on_attach = default_on_attach;
  cmd = {"${pkgs.tailwindcss-language-server}/bin/tailwindcss-language-server", "--stdio"},
  handlers = handlers,
}
''
