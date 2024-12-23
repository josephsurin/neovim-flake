{ pkgs, ... }:

/* lua */ ''
lspconfig.eslint.setup {
  capabilities = capabilities;
  on_attach = default_on_attach;
  cmd = {"${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-eslint-language-server", "--stdio"},
  handlers = handlers,
}
''
