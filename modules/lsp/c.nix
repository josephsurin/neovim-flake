{ config, pkgs, ... }:

/* lua */ ''
lspconfig.clangd.setup {
  capabilities = capabilities;
  on_attach = default_on_attach;
  cmd = {"${config.vim.lsp.languages.c-cmd}"},
  handlers = handlers,
}
''
