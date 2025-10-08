{ pkgs, ... }:

/* lua */ ''
vim.lsp.config('tailwindcss', {
  capabilities = capabilities;
  on_attach = default_on_attach;
  cmd = {"${pkgs.tailwindcss-language-server}/bin/tailwindcss-language-server", "--stdio"},
  handlers = handlers,
})
vim.lsp.enable('tailwindcss')
''
