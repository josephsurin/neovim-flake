{ pkgs, ... }:

/* lua */ ''
vim.lsp.config('pyright', {
  capabilities = capabilities;
  on_attach = default_on_attach;
  cmd = {"${pkgs.pyright}/bin/pyright-langserver", "--stdio"},
  handlers = handlers,
})
vim.lsp.enable('pyright')
''
