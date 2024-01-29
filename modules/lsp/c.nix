{ pkgs, ... }:

/* lua */ ''
lspconfig.clangd.setup {
  capabilities = capabilities;
  on_attach = default_on_attach;
  cmd = {"${pkgs.clang-tools}/bin/clangd"},
  handlers = handlers,
}
''
