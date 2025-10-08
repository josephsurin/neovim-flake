{ config, pkgs, ... }:

/* lua */ ''
vim.lsp.config('clangd', {
  capabilities = capabilities;
  on_attach = default_on_attach;
  cmd = {"${config.vim.lsp.languages.c-cmd}"},
  handlers = handlers,
})
vim.lsp.enable('clangd')
''
